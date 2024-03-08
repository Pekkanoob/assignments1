create database techshop;
use techshop;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Inventory table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    QuantityInStock INT,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sample entries for Customers table
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Rajesh', 'Kumar', 'rajesh@example.com', '9876543210', '123 Main Street, Bangalore'),
('Priya', 'Sharma', 'priya@example.com', '8765432109', '456 Oak Avenue, Mumbai'),
('Amit', 'Patel', 'amit@example.com', '7654321098', '789 Elm Street, Delhi'),
('Neha', 'Joshi', 'neha@example.com', '6543210987', '101 Maple Lane, Kolkata'),
('Suresh', 'Singh', 'suresh@example.com', '5432109876', '222 Pine Street, Chennai');


-- Sample entries for Products table
INSERT INTO Products (ProductName, Description, Price) VALUES
('Laptop', '15.6-inch, Intel Core i5, 8GB RAM, 256GB SSD', 899.99),
('Smartphone', '6.2-inch, 128GB storage, 12MP camera', 699.99),
('Tablet', '10.1-inch, Android OS, 64GB storage', 299.99),
('Smartwatch', 'Fitness tracker with heart rate monitor', 149.99),
('Bluetooth Speaker', 'Portable speaker with built-in microphone', 79.99);


-- Sample entries for Orders table
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-03-08', 1999.97),
(2, '2024-03-08', 899.99),
(3, '2024-03-08', 599.98),
(4, '2024-03-08', 149.99),
(5, '2024-03-08', 359.96);


-- Sample entries for OrderDetails table
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 2),
(3, 4, 1),
(4, 5, 2),
(5, 1, 1),
(5, 3, 1),
(5, 4, 1),
(5, 5, 1);

-- Sample entries for Inventory table
INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 25, '2024-03-08'),
(2, 30, '2024-03-08'),
(3, 20, '2024-03-08'),
(4, 40, '2024-03-08'),
(5, 50, '2024-03-08');



-- Working on select, where, betwen, and, like commands

SELECT FirstName, LastName, Email
FROM Customers;

SELECT o.OrderID, o.OrderDate, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

INSERT INTO Customers (FirstName, LastName, Email, Address)
VALUES ('John', 'Doe', 'john.doe@example.com', '123 New Street, City, Country');


UPDATE Orders AS o
SET TotalAmount = (
    SELECT SUM(p.Price * od.Quantity)
    FROM OrderDetails AS od
    JOIN Products AS p ON od.ProductID = p.ProductID
    WHERE od.OrderID = o.OrderID
);

INSERT INTO Products (ProductName, description, Price)
VALUES ('New Gadget', 'Electronic', 199.99);



-- Using Order by, group by, having and joins

SELECT o.OrderID, o.OrderDate, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT p.ProductName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

SELECT c.FirstName, c.LastName, c.Email, c.Phone
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalQuantityOrdered DESC
LIMIT 1;

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, AVG(o.TotalAmount) AS AvgOrderValue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

SELECT o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, MAX(o.TotalAmount) AS TotalRevenue
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID;

SELECT p.ProductName, COUNT(od.OrderDetailID) AS OrderCount
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID;

SELECT SUM(o.TotalAmount) AS TotalRevenue
FROM Orders o
WHERE o.OrderDate BETWEEN '2024-03-01' AND '2024-03-06';


-- Sub Queries

SELECT FirstName, LastName, Email
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);

SELECT COUNT(*) AS TotalProducts
FROM Products;

SELECT (
    SELECT SUM(TotalAmount)
    FROM Orders
) AS TotalRevenue;

SELECT FirstName, LastName, OrderCount
FROM (
    SELECT c.FirstName, c.LastName, COUNT(*) AS OrderCount
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
    ORDER BY OrderCount DESC
) AS CustomerOrders
LIMIT 1;

SELECT (
    SELECT AVG(TotalAmount)
    FROM Orders
) AS AvgOrderValue;

SELECT c.FirstName, c.LastName, OrderCount
FROM Customers c
JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
) AS CustomerOrders ON c.CustomerID = CustomerOrders.CustomerID;


