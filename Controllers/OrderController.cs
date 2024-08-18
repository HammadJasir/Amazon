using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PdfSharpCore.Drawing;
using PdfSharpCore.Pdf;
using UPC_DropDown.Models;

public class OrderController : Controller
{
    private readonly ApplicationDbContext _db;

    public OrderController(ApplicationDbContext db)
    {
        _db = db;
    }

    public IActionResult OrderList()
    {
        var orders = _db.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.Product).ToList();
        return View(orders);
    }

    [HttpPost]
    public IActionResult CreateOrder([FromBody] List<int> selectedItems)
    {
        try
        {
            if (selectedItems == null || !selectedItems.Any())
            {
                return Json(new { success = false, message = "No items selected for the order." });
            }

            // Assuming the user is logged in and you have the UserID
            int userId = 2; // Replace with the actual logged-in user ID

            var cartItems = _db.CartItem.Include(c => c.Product)
                                        .Where(c => selectedItems.Contains(c.CartId) && c.UserID == userId)
                                        .ToList();
            if (!cartItems.Any())
            {
                return Json(new { success = false, message = "No items in cart to order" });
            }

            // Generate the next order number from the sequence
            int orderNumber = _db.GetNextOrderNumber();

            var order = new Order
            {
                OrderNumber = orderNumber, // Assign the generated order number
                UserID = userId,
                OrderDate = DateTime.Now,
                TotalPrice = cartItems.Sum(ci => ci.Product.ProductPrice * ci.Quantity),
                OrderItems = cartItems.Select(ci => new OrderItem
                {
                    ProductID = ci.ProductID,
                    Quantity = ci.Quantity,
                    Price = ci.Product.ProductPrice
                }).ToList()
            };

            _db.Orders.Add(order);
            _db.CartItem.RemoveRange(cartItems); // Clear the selected items from the cart
            _db.SaveChanges();

            return Json(new { success = true });
        }
        catch (Exception ex)
        {
            // Log the exception (you can use a logging framework)
            var errorMessage = $"Error creating order: {ex.Message}";
            if (ex.InnerException != null)
            {
                errorMessage += $"; Inner exception: {ex.InnerException.Message}";
            }
            Console.WriteLine(errorMessage);

            return Json(new { success = false, message = errorMessage });
        }
    }

    [HttpPost]
    public IActionResult DeleteOrder(int orderId)
    {
        try
        {
            var order = _db.Orders.Include(o => o.OrderItems).FirstOrDefault(o => o.OrderId == orderId);
            if (order == null)
            {
                return Json(new { success = false, message = "Order not found" });
            }

            _db.Orders.Remove(order);
            _db.SaveChanges();

            return Json(new { success = true });
        }
        catch (Exception ex)
        {
            var errorMessage = $"Error deleting order: {ex.Message}";
            if (ex.InnerException != null)
            {
                errorMessage += $"; Inner exception: {ex.InnerException.Message}";
            }
            Console.WriteLine(errorMessage);

            return Json(new { success = false, message = errorMessage });
        }
    }

    [HttpPost]
    public IActionResult Checkout(int orderId)
    {
        try
        {
            var order = _db.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.Product)
                                  .FirstOrDefault(o => o.OrderId == orderId);

            if (order == null)
            {
                return Json(new { success = false, message = "Order not found." });
            }

            // Additional logic (e.g., updating order status)

            // Redirect to ThankYou page with the orderId
            return Json(new { success = true, redirectUrl = Url.Action("ThankYou", new { orderId }) });
        }
        catch (Exception ex)
        {
            var errorMessage = $"Error during checkout: {ex.Message}";
            if (ex.InnerException != null)
            {
                errorMessage += $"; Inner exception: {ex.InnerException.Message}";
            }
            Console.WriteLine(errorMessage);

            return Json(new { success = false, message = errorMessage });
        }
    }

    public IActionResult ThankYou(int orderId)
    {
        var order = _db.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.Product)
                              .FirstOrDefault(o => o.OrderId == orderId);

        if (order == null)
        {
            return NotFound();
        }

        return View(order);
    }


    public IActionResult PaymentPage(int orderId)
    {
        // Retrieve the order based on orderId
        var order = _db.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.Product)
                              .FirstOrDefault(o => o.OrderId == orderId);
        if (order == null)
        {
            return NotFound();
        }
        return View(order);
    }

    public IActionResult DownloadPdf(int orderId)
    {
        // Retrieve the order based on orderId
        var order = _db.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.Product)
                              .FirstOrDefault(o => o.OrderId == orderId);
        if (order == null)
        {
            return NotFound();
        }

        // Create PDF document
        using (var stream = new MemoryStream())
        {
            var document = new PdfDocument();
            var page = document.AddPage();
            var gfx = XGraphics.FromPdfPage(page);
            var font = new XFont("Verdana", 12, XFontStyle.Regular);

            // Write order details
            gfx.DrawString($"Order ID: {order.OrderId}", font, XBrushes.Black, new XRect(20, 20, page.Width, page.Height), XStringFormats.TopLeft);
            gfx.DrawString($"Order Number: {order.OrderNumber}", font, XBrushes.Black, new XRect(20, 40, page.Width, page.Height), XStringFormats.TopLeft);
            gfx.DrawString($"Order Date: {order.OrderDate.ToString("yyyy-MM-dd HH:mm")}", font, XBrushes.Black, new XRect(20, 60, page.Width, page.Height), XStringFormats.TopLeft);
            gfx.DrawString($"Total Price: ₹ {order.TotalPrice.ToString("N2")}", font, XBrushes.Black, new XRect(20, 80, page.Width, page.Height), XStringFormats.TopLeft);

            // Write order items
            int yPosition = 120;
            foreach (var item in order.OrderItems)
            {
                gfx.DrawString($"{item.Product.ProductName} - {item.Quantity} x ₹ {item.Price.ToString("N2")}", font, XBrushes.Black, new XRect(20, yPosition, page.Width, page.Height), XStringFormats.TopLeft);
                yPosition += 20;
            }

            document.Save(stream, false);
            var fileName = $"Order_{order.OrderNumber}.pdf";
            return File(stream.ToArray(), "application/pdf", fileName);
        }
    }
}

