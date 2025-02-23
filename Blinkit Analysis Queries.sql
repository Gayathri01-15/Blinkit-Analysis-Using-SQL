use blinkitdb;
SHOW TABLES;

----------------------------------------------------- Basic Queries ------------------------------------------------------

-- 1)To View the first few records of each table: 
SELECT * FROM Customers LIMIT 10;
SELECT * FROM Orders LIMIT 10;
SELECT * FROM Order_Details LIMIT 10;

-- 2)To Count total records in each table :
SELECT COUNT(*) AS Total_Customers FROM Customers;
SELECT COUNT(*) AS Total_Orders FROM Orders;
SELECT COUNT(*) AS Total_OrderDetails FROM Order_Details;

-- 3)To Check for NULL values in critical columns: 
SELECT COUNT(*) AS Null_CustomerID FROM Customers WHERE CustomerID IS NULL;
SELECT COUNT(*) AS Null_OrderID FROM Orders WHERE OrderID IS NULL;
SELECT COUNT(*) AS Null_ProductName FROM Order_Details WHERE ProductName IS NULL;

------------------------------------------------- DQL --------------------------------------------------------------------

SELECT * FROM Customers WHERE Phone = 8936103237;

SELECT * FROM Customers WHERE Name = 'Amit Khan';

SELECT * FROM Customers WHERE Name LIKE 'A%';

SELECT * FROM Customers WHERE Name LIKE 'A%N';

SELECT * FROM Customers WHERE Name NOT LIKE 'A_a_%';

SELECT * FROM Customers WHERE City != 'Jaipur';

SELECT * FROM Customers WHERE City <> 'Jaipur';

SELECT * FROM Customers WHERE City = 'Jaipur';

SELECT * FROM Customers WHERE CustomerID = 30;

SELECT * FROM Customers WHERE CustomerID <= 22;

SELECT * FROM Customers WHERE CustomerID > 25;

SELECT * FROM Customers WHERE CustomerID BETWEEN 25 AND 35;

SELECT * FROM Customers WHERE CustomerID NOT BETWEEN 5 AND 15;

SELECT * FROM Customers WHERE CustomerID IN (101,105,108); 

----------------------------------------------------- Aggregate Functions ------------------------------------------------

SELECT SUM(TotalAmount) AS OverallTotalAmount FROM Orders;

SELECT COUNT(*) AS TotalCustomers FROM Customers;

SELECT AVG(TotalAmount) AS AverageTotalAmount FROM Orders;

SELECT MIN(TotalAmount) AS LowestTotalAmount FROM Orders;

SELECT MAX(TotalAmount) AS HighestTotalAmount FROM Orders;

SELECT DISTINCT City FROM Customers;

SELECT DISTINCT City FROM Customers ORDER BY City ASC;

SELECT * FROM Customers ORDER BY CustomerID DESC;

----------------------------------------------------------- Functions ----------------------------------------------------

SELECT UPPER(Name) AS CustomerName FROM Customers;

SELECT LOWER(Name) AS CustomerName FROM Customers;

SELECT Name,LENGTH(Name) AS NameLength FROM Customers;

SELECT SUBSTR(Name,1,5) FROM Customers;

--------------------------------------------------------- Customer Analysis ----------------------------------------------

-- 4)List of cities with the highest number of customers
SELECT City, COUNT(CustomerID) AS Customer_Count
FROM Customers
GROUP BY City
ORDER BY Customer_Count DESC;

-- 5)Customers Who Placed Maximum Orders
SELECT C.CustomerID, C.Name, 
       (SELECT COUNT(O.OrderID) 
        FROM Orders O 
        WHERE O.CustomerID = C.CustomerID) AS TotalOrders
FROM Customers C
ORDER BY TotalOrders DESC
LIMIT 10;

-- 6)Find customers who spent the most money
SELECT C.CustomerID, C.Name, 
       (SELECT SUM(O.TotalAmount) 
        FROM Orders O 
        WHERE O.CustomerID = C.CustomerId) AS TotalSpent
FROM Customers C
ORDER BY TotalSpent DESC
LIMIT 10;

-- 7) Customers with the Largest orders by total amount
SELECT c.CustomerID, c.Name, 
       (SELECT MAX(O.TotalAmount) 
        FROM Orders O 
        WHERE O.CustomerID = C.CustomerID) AS LargestOrder
FROM Customers C
ORDER BY LargestOrder DESC
LIMIT 10;
-------------------------------------------------- Sales and Revenue Analysis --------------------------------------------

-- 8)Calculate total revenue generated
SELECT SUM(TotalAmount) AS Total_Revenue
FROM Orders;

-- 9)Find the average order value (AOV)
SELECT AVG(TotalAmount) AS Average_Order_Value
FROM Orders;

-- 10)Identify the top 10 most ordered products
SELECT ProductName, SUM(Quantity) AS Total_Quantity_Sold
FROM Order_Details
GROUP BY ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- 11)Find products that generated the highest revenue (Top 10 products by revenue)
SELECT ProductName, SUM(Quantity * PricePerUnit) AS Total_Revenue
FROM Order_Details
GROUP BY ProductName
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 12)Monthly revenue trend
SELECT YEAR(OrderDateTime) AS Year, MONTH(OrderDateTime) AS Month, SUM(TotalAmount) AS Monthly_Revenue
FROM Orders
GROUP BY YEAR(OrderDateTime), MONTH(OrderDateTime)
ORDER BY Year, Month;

-- 13)Daily revenue trend
SELECT DATE(OrderDateTime) AS Order_Date, SUM(TotalAmount) AS Daily_Revenue
FROM Orders
GROUP BY Order_Date
ORDER BY Order_Date;

-- 14)Find total revenue by city
SELECT C.City, SUM(O.TotalAmount) AS Total_Revenue
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.City
ORDER BY Total_Revenue DESC;

----------------------------------------------------- Order Analysis -----------------------------------------------------
-- 15)Count of orders per delivery status
SELECT DeliveryStatus, COUNT(OrderId) AS Total_Orders
FROM Orders
GROUP BY DeliveryStatus;

-- 16)To know the Time difference between Orders and Deliveries.
SELECT OrderID, OrderDateTime, DeliveryDateTime, 
       TIMESTAMPDIFF(HOUR, OrderDateTime, DeliveryDateTime) AS HoursDifference,
       TIMESTAMPDIFF(MINUTE, OrderDateTime, DeliveryDateTime) AS MinutesDifference,
       TIMESTAMPDIFF(SECOND, OrderDateTime, DeliveryDateTime) AS SecondsDifference
FROM Orders;

-- 17)Identify the average delivery time
SELECT AVG(TIMESTAMPDIFF(MINUTE, OrderDateTime, DeliveryDateTime)) AS Average_Delivery_Time_Minutes
FROM Orders
WHERE DeliveryStatus = 'Delivered';

-- 18)Find the total number of orders in a day.
SELECT DATE(OrderDateTime) AS Order_Date, COUNT(OrderId) AS Total_Orders
FROM Orders
GROUP BY Order_Date
ORDER BY Total_Orders DESC;

-- 19)Find orders with the most products purchased (highest total quantity)
SELECT OrderID, SUM(Quantity) AS Total_Quantity
FROM Order_Details
GROUP BY OrderID
ORDER BY Total_Quantity DESC
LIMIT 10;

-- 20)Identify peak order times (hourly)
SELECT HOUR(OrderDateTime) AS Hour, COUNT(OrderID) AS Total_Orders
FROM Orders
GROUP BY Hour 
ORDER BY HOUR ASC;

-- 21)Find the total number of orders placed in each city
SELECT C.City, COUNT(O.OrderID) AS Total_Orders
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.City
ORDER BY Total_Orders DESC;

-- 22) Orders That Contain a Specific Product.
SELECT O.OrderID, O.CustomerID, O.OrderDateTime, O.TotalAmount 
FROM Orders O
WHERE O.OrderID IN (SELECT OD.OrderID FROM Order_Details OD WHERE OD.ProductName = 'Tata Salt');

------------------------------------------------------ Product Performance Analysis -------------------------------------

-- 23)Find the products that were ordered the least
SELECT ProductName, SUM(Quantity) AS Total_Quantity
FROM Order_Details
GROUP BY ProductName
ORDER BY Total_Quantity ASC
LIMIT 10;

-- 24)Top products sold by quantity and revenue together
SELECT ProductName, SUM(Quantity) AS Total_Quantity_Sold, SUM(Quantity * PricePerUnit) AS Total_Revenue
FROM Order_Details
GROUP BY ProductName
ORDER BY Total_Revenue DESC, Total_Quantity_Sold DESC
LIMIT 10;

-- 25)Identify products with the highest average price per unit
SELECT ProductName, AVG(PricePerUnit) AS Avg_Price
FROM Order_Details
GROUP BY ProductName
ORDER BY Avg_Price DESC
LIMIT 10;

-- 26)Calculate the total quantity of products sold by city
SELECT C.City, SUM(OD.Quantity) AS Total_Quantity
FROM Order_Details OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.City
ORDER BY Total_Quantity DESC;

-- 27)Find customers with orders containing more than 20 items (quantity)
SELECT O.OrderID, C.CustomerID, C.Name, SUM(OD.Quantity) AS Total_Quantity
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Order_Details OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, C.CustomerID, C.Name
HAVING Total_Quantity > 20;

------------------------------------------------ Delivery Performance Analysis -------------------------------------------

-- 28)Identify orders with the shortest delivery time
SELECT OrderID, TIMESTAMPDIFF(MINUTE, OrderDateTime, DeliveryDateTime) AS Delivery_Time_Minutes
FROM Orders
WHERE DeliveryStatus = 'Delivered'
ORDER BY Delivery_Time_Minutes ASC
LIMIT 10;

-- 29)Delivery performance by city
SELECT C.City, AVG(TIMESTAMPDIFF(MINUTE, O.OrderDateTime, O.DeliveryDateTime)) AS Avg_Delivery_Time
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE O.DeliveryStatus = 'Delivered'
GROUP BY C.City
ORDER BY Avg_Delivery_Time;

--------------------------------------------- Customer Behavior & Engagement Analysis ------------------------------------

-- 30)Find customers who placed multiple orders in a single day
SELECT CustomerID, DATE(OrderDateTime) AS OrderDate, COUNT(OrderId) AS OrderCount
FROM Orders
GROUP BY CustomerID, OrderDate
HAVING COUNT(OrderID) > 1
ORDER BY OrderCount DESC;

-- 31)Find the number of unique customers who placed orders each month
SELECT YEAR(OrderDateTime) AS Year, MONTH(OrderDateTime) AS Month, COUNT(DISTINCT CustomerId) AS Unique_Customers
FROM Orders
GROUP BY YEAR(OrderDateTime), MONTH(OrderDateTime)
ORDER BY Year, Month;

-- 32)List of customers who spent more than $20,000 in total
SELECT C.CustomerID, C.Name, SUM(O.TotalAmount) AS Total_Spent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name
HAVING SUM(O.TotalAmount) > 20000
ORDER BY Total_Spent DESC;

-------------------------------------------------------- Views ---------------------------------------------------
DROP VIEW IF EXISTS Customers_100_200;

CREATE VIEW Customers_100_200 AS 
SELECT CustomerID, Name, City 
FROM Customers 
WHERE CustomerID BETWEEN 100 AND 200 
WITH CHECK OPTION;

SELECT * FROM Customers_100_200;

SELECT * FROM Customers_100_200
WHERE CustomerID = 101;

------------------------------------------------------------------------------
DROP VIEW IF EXISTS Customers_200_300;

CREATE VIEW Customers_200_300 AS
SELECT 
	C.CustomerID, C.Name, C.Address, C.City, O.DeliveryStatus
FROM Customers as C
JOIN Orders as O
ON C.CustomerID = O.CustomerID
WHERE C.customerID BETWEEN 200 AND 300
WITH CHECK OPTION;

SELECT * FROM Customers_200_300;

SELECT * FROM Customers_200_300
WHERE CustomerID BETWEEN 201 AND 205;

-----------------------------------------------------------------------------
DROP VIEW IF EXISTS Customers_250_300;

CREATE VIEW Customers_250_300 AS
SELECT 
	C.CustomerID, OD.OrderID, OD.ProductName, OD.Quantity, OD.PricePerUnit, O.TotalAmount, O.DeliveryStatus 
FROM Order_Details AS OD
JOIN Orders AS O
ON OD.OrderID = O.OrderID
JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.CustomerID BETWEEN 250 AND 300
ORDER BY CustomerID ASC
WITH CHECK OPTION;

SELECT * FROM Customers_250_300;

------------------------------------------------------------ End ---------------------------------------------------------