
--USE AmazonApp
--GO

--/** Object:  Table [dbo].[Products]    Script Date: 1/08/2024 1:36:38 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Products](
--	[ProductID] [int] IDENTITY(1,1) NOT NULL,
--	[ProductName] [nvarchar](100) NOT NULL,
--	[ProductPrice] [int] NULL,
--	[ProductDescription] [nvarchar](max) NULL,
--	[CategoryID] [int] NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[ProductID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([CategoryID])
--REFERENCES [dbo].[Categories] ([CategoryID])
--GO




--USE AmazonApp
--GO

--/** Object:  Table [dbo].[CartItem]    Script Date: 1/08/2024 6:57:32 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[CartItem](
--	[CartId] [int] IDENTITY(1,1) NOT NULL,
--	[ProductID] [int] NOT NULL,
--	[UserID] [int] NOT NULL,
--	[Quantity] [int] NOT NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[CartId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD FOREIGN KEY([ProductID])
--REFERENCES [dbo].[Products] ([ProductID])
--GO

--ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD FOREIGN KEY([UserID])
--REFERENCES [dbo].[Users] ([UserID])
--GO

--USE AmazonApp
--GO

--/** Object:  Table [dbo].[Categories]    Script Date: 1/08/2024 6:58:40 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Categories](
--	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
--	[CategoryName] [nvarchar](100) NOT NULL,
--	[CategoryDescription] [nvarchar](max) NULL,
--	[CategoryStatus] [nvarchar](100) NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[CategoryID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--USE AmazonApp
--GO

--/** Object:  Table [dbo].[OrderItems]    Script Date: 1/08/2024 6:59:51 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[OrderItems](
--	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
--	[OrderId] [int] NOT NULL,
--	[ProductID] [int] NOT NULL,
--	[Quantity] [int] NOT NULL,
--	[Price] [decimal](18, 2) NOT NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[OrderItemId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([OrderId])
--REFERENCES [dbo].[Orders] ([OrderId])
--GO

--ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([ProductID])
--REFERENCES [dbo].[Products] ([ProductID])
--GO

--USE AmazonApp
--GO

--/** Object:  Table [dbo].[Orders]    Script Date: 1/08/2024 7:01:15 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Orders](
--	[OrderId] [int] IDENTITY(1,1) NOT NULL,
--	[OrderNumber] [int] NOT NULL,
--	[UserID] [int] NOT NULL,
--	[OrderDate] [datetime] NOT NULL,
--	[TotalPrice] [decimal](18, 2) NOT NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[OrderId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--USE AmazonApp
--GO

--/** Object:  Table [dbo].[Users]    Script Date: 1/08/2024 7:04:51 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[Users](
--	[UserID] [int] IDENTITY(1,1) NOT NULL,
--	[UserName] [nvarchar](100) NOT NULL,
--	[UserEmail] [nvarchar](100) NULL,
--	[UserPassword] [nvarchar](max) NULL,
--	[Salary] [decimal](10, 2) NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[UserID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--select * from CartItem

-----Stored Procedures
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[AddCartItem]    Script Date: 2/08/2024 4:36:21 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[AddCartItem]
--    @UserId INT,
--    @ProductId INT,
--    @Quantity INT
--AS
--BEGIN
--    INSERT INTO CartItems (UserId, ProductId, Quantity)
--    VALUES (@UserId, @ProductId, @Quantity);
--END
--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[ClearCart]    Script Date: 2/08/2024 4:36:55 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[ClearCart]
--    @UserId INT
--AS
--BEGIN
--    DELETE FROM CartItems
--    WHERE UserId = @UserId;
--END
--GO USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[GetCartItems]    Script Date: 2/08/2024 4:37:21 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[GetCartItems]
--    @UserId INT
--AS
--BEGIN
--    SELECT CartItemId, UserId, ProductId, Quantity
--    FROM CartItems
--    WHERE UserId = @UserId;
--END

--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[GetCategories]    Script Date: 2/08/2024 4:37:44 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[GetCategories]
--AS
--BEGIN
--    SELECT 
--        CategoryID,
--        CategoryName,
--        CategoryDescription,
--        CategoryStatus
--    FROM 
--        Categories
--    ORDER BY 
--        CategoryID;
--END;

--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[GetProductCountByCategory]    Script Date: 2/08/2024 4:38:03 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[GetProductCountByCategory]
--AS
--BEGIN
--    SET NOCOUNT ON;

--    SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID) AS ProductCount
--    FROM Categories c
--    INNER JOIN Products p ON c.CategoryID = p.CategoryID
--    GROUP BY c.CategoryID, c.CategoryName
--    ORDER BY c.CategoryName; -- Optional: Order by category name or ID
--END

--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[GetProducts]    Script Date: 2/08/2024 4:38:28 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[GetProducts]
--    @PageNumber INT = null,
--    @PageSize INT = 10
--AS
--BEGIN
--    SET NOCOUNT ON;
--	IF ( @PageNumber IS NULL
--             OR @PageNumber = 0
--           )
--            BEGIN 
--                SET @PageNumber = 1
--                SET @PageSize = 10
--            END
--    -- Calculate the offset
--    DECLARE @Offset INT;
--    SET @Offset = (@PageNumber - 1) * @PageSize;

--    SELECT 
--        p.ProductID,
--        p.ProductName,
--        p.ProductPrice,
--        p.ProductDescription,
--        c.CategoryID
--    FROM 
--        Products p
--    INNER JOIN 
--        Categories c ON p.CategoryID = c.CategoryID
--    ORDER BY 
--        p.ProductName
--    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
--END



-----------------------------------------------------------------------------------
--CREATE TABLE Orders (
--    OrderId INT PRIMARY KEY IDENTITY,
--    OrderNumber INT NOT NULL,
--    UserID INT NOT NULL,
--    OrderDate DATETIME NOT NULL,
--    TotalPrice DECIMAL(18, 2) NOT NULL
--);

--CREATE TABLE OrderItems (
--    OrderItemId INT PRIMARY KEY IDENTITY,
--    OrderId INT NOT NULL,
--    ProductID INT NOT NULL,
--    Quantity INT NOT NULL,
--    Price DECIMAL(18, 2) NOT NULL,
--    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
--    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
--);

---- Optional: Create a sequence for generating OrderNumber
--CREATE SEQUENCE dbo.OrderNumbers AS INT START WITH 10000 INCREMENT BY 1;

--select * from OrderItems
--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 2/08/2024 4:38:49 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[GetUsers]
--AS
--BEGIN
--    SELECT UserID, UserName, UserEmail, UserPassword, Salary
--    FROM Users;
--END
--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[RemoveCartItem]    Script Date: 2/08/2024 4:39:10 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[RemoveCartItem]
--    @CartItemId INT
--AS
--BEGIN
--    DELETE FROM CartItems
--    WHERE CartItemId = @CartItemId;
--END
--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[SearchCategories]    Script Date: 2/08/2024 4:39:33 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[SearchCategories]
--    @keyword NVARCHAR(100)
--AS
--BEGIN
--    SET NOCOUNT ON;

--    IF @keyword IS NULL OR LEN(LTRIM(RTRIM(@keyword))) = 0
--    BEGIN
--        SELECT CategoryID, CategoryName, CategoryDescription, CategoryStatus
--        FROM Categories; 
--    END
--    ELSE
--    BEGIN
--        SELECT CategoryID, CategoryName, CategoryDescription, CategoryStatus
--        FROM Categories
--        WHERE CategoryName LIKE '%' + @keyword + '%';
--    END
--END
--GO
-- USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[SearchProducts]    Script Date: 2/08/2024 4:39:55 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[SearchProducts]
--    @keyword NVARCHAR(100)
--AS
--BEGIN
--    SET NOCOUNT ON;

--    IF @keyword IS NULL OR LEN(LTRIM(RTRIM(@keyword))) = 0
--    BEGIN
--        SELECT ProductID, ProductName, ProductPrice, ProductDescription,CategoryID
--        FROM Products; 
--    END
--    ELSE
--    BEGIN
--        SELECT ProductID, ProductName, ProductPrice, ProductDescription,CategoryID
--        FROM Products
--        WHERE ProductName LIKE '%' + @keyword + '%';
--    END
--END


--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[SearchUsers]    Script Date: 2/08/2024 4:40:11 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE [dbo].[SearchUsers]
--    @keyword NVARCHAR(100)
--AS
--BEGIN
--    SET NOCOUNT ON;

--    IF @keyword IS NULL OR LEN(LTRIM(RTRIM(@keyword))) = 0
--    BEGIN
--        SELECT UserID, UserName, UserEmail, UserPassword
--        FROM Users; 
--    END
--    ELSE
--    BEGIN
--        SELECT UserID, UserName, UserEmail, UserPassword
--        FROM Users
--        WHERE UserName LIKE '%' + @keyword + '%';
--    END
--END
--GO
--USE AmazonApp
--GO

--/** Object:  StoredProcedure [dbo].[UpdateCartItem]    Script Date: 2/08/2024 4:40:40 PM **/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[UpdateCartItem]
--    @CartItemId INT,
--    @Quantity INT
--AS
--BEGIN
--    UPDATE CartItems
--    SET Quantity = @Quantity
--    WHERE CartItemId = @CartItemId;
--END
--GO

--use AmazonApp
--select * from Categories
--INSERT INTO categories (CategoryID, CategoryName, CategoryDescription,CategoryStatus)
--VALUES (1, 'Electronics', 'Devices and gadgets',1);

--select* from OrderItems

--use AmazonApp
--Drop table Orders

--CREATE TABLE Orders (
--   OrderId INT PRIMARY KEY IDENTITY,
--    OrderNumber INT NOT NULL,
--    UserID INT NOT NULL,
--    OrderDate DATETIME NOT NULL,
--    TotalPrice DECIMAL(18, 2) NOT NULL
--);

--CREATE TABLE OrderItems (
--    OrderItemId INT PRIMARY KEY IDENTITY,
--    OrderId INT NOT NULL,
--    ProductID INT NOT NULL,
--    Quantity INT NOT NULL,
--    Price DECIMAL(18, 2) NOT NULL,
--    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
--    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
--);

---- Optional: Create a sequence for generating OrderNumber
--CREATE SEQUENCE dbo.OrderNumber AS INT START WITH 10000 INCREMENT BY 1;