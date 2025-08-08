
-- Create tables

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    ContactName VARCHAR(100),
    Country VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample data

INSERT INTO Customers VALUES
(1, 'Alfreds Futterkiste', 'Maria Anders', 'Germany'),
(2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Mexico'),
(3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mexico');

INSERT INTO Products VALUES
(1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00),
(2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00),
(3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00);

INSERT INTO Orders VALUES
(1, 1, '2023-08-01', 1),
(2, 2, '2023-08-02', 2),
(3, 3, '2023-08-03', 1);

INSERT INTO OrderDetails VALUES
(1, 1, 1, 5),
(2, 1, 2, 3),
(3, 2, 3, 10),
(4, 3, 2, 1);

SELECT * FROM Customers;
SELECT o.OrderID, c.CustomerName, p.ProductName, od.Quantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID;
SELECT c.Country, COUNT(*) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country;
SELECT CustomerName FROM Customers
WHERE CustomerID IN (
  SELECT CustomerID FROM Orders WHERE OrderDate >= '2023-08-01'
);

SELECT 
    p.ProductName,
    SUM(od.Quantity * p.Price) AS TotalRevenue,
    AVG(p.Price) AS AveragePrice
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalRevenue DESC;

CREATE VIEW Product_Sales_Summary AS
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalUnitsSold,
    SUM(od.Quantity * p.Price) AS TotalRevenue,
    AVG(p.Price) AS AvgUnitPrice
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName;
SELECT * FROM Product_Sales_Summary;
CREATE INDEX idx_orderdetails_productid ON OrderDetails(ProductID);
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);




