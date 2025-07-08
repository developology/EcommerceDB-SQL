-- • JOINS (INNER, LEFT, RIGHT, FULL) 
-- 1. List all products along with their category names. 
SELECT * 
FROM Products 
LEFT JOIN Categories  
ON Products.CategoryID = Categories.CategoryID; 
              
-- 2. Show each customer's order count 
SELECT Customers.CustomerID, Customers.Name,  
COUNT(Orders.OrderID) AS OrderCount 
FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
GROUP BY Customers.CustomerID, Customers.Name; 
      
-- 3. List product names and their discount amounts. 
select products.name, products.productid,  
discounts.DiscountAmount 
from products right join discounts  
on products.productid= discounts.productid; 
 
 
-- 4. Show order details with product names and prices. 
SELECT  OrderDetails.DetailID, OrderDetails.OrderID,  OrderDetails.ProductID,  
Products.Name, Products.Price 
FROM OrderDetails 
JOIN Products 
ON OrderDetails.ProductID = Products.ProductID; 
 
-- 5. Find shipping info with order and customer names. 
SELECT Shipping.ShippingID, Shipping.OrderID, Shipping.ShipDate, Shipping.DeliveryDate, 
Customers.CustomerID,Customers.Name AS CustomerName 
FROM Shipping 
JOIN Orders ON Shipping.OrderID = Orders.OrderID 
JOIN Customers ON Orders.CustomerID = Customers.CustomerID; 
 
-- 6. Display all customers and any reviews they’ve written. 
select customers.CustomerID, customers.Name, customers.email,  
reviews.rating, reviews.Comment  
from customers join reviews  
on customers.customerID = reviews.customerID; 
       
-- 7. List all products with their category and discount (if any). 
Select products.ProductID, products.Name, products.Price, Products.CategoryID 
,categories.CategoryName,discounts.DiscountAmount 
from products  
join categories on products.categoryID = categories.categoryID  
join discounts on Products.productID = discounts.ProductID; 
             
-- 8. Find the top 5 customers who spent the most in total. 
select customers.customerID, customers.Name, 
SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent 
from customers 
JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
JOIN Products ON OrderDetails.ProductID = Products.ProductID 
GROUP BY Customers.CustomerID 
ORDER BY TotalSpent DESC 
LIMIT 5; 
 
 
 
-- 9. Display customers who haven’t placed any orders. 
Select customers.customerID, customers.Name, customers.Email 
FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
WHERE Orders.OrderID IS NULL; 
 
-- 10. Show each customer's name, their order ID, and the product names they ordered. 
select customers.customerID, orders.orderID, products.name from customers            
join orders on customers.customerID = orders.customerID  
JOIN orderDetails on orders.OrderID = orderDetails.orderID 
JOIN products on orderDetails.ProductID= products.productID; 
            
-- • SUBQUERIES 
-- 11. Show customers who have never written a review. 
SELECT CustomerID, Name, Email  
FROM Customers 
WHERE CustomerID NOT IN ( 
SELECT  CustomerID 
FROM Review 
); 
 
-- 12. List products that have never been ordered. 
SELECT ProductID, Name, Price 
FROM products 
WHERE productID NOT  IN ( 
SELECT  ProductID 
FROM orderdetails 
); 
 
-- 13. Find the most expensive product in all. 
SELECT CategoryID, Name AS ProductName, Price  
FROM Products  
WHERE Price = ( 
SELECT MAX(Price) 
FROM Products 
); 
 
-- 14. List all products with price greater than the average price of all products. 
Select name,price from products where price >= ( 
select AVG(price)  
from products 
); 
 
 
-- 15. Show products that have never been ordered. 
select name, productID from products 
where ProductID NOT in ( 
select productID from orderDetails   
); 
 
-- 16. Show customers who have only written reviews with 5-star ratings. 
SELECT Name, Email FROM Customers  
WHERE CustomerID IN ( 
SELECT CustomerID  
FROM Reviews  
WHERE Rating = 5 
); 
 
-- 17. Find products with a price higher than the average price. 
select price, name from products where ( 
select AVG(price) 
from products 
); 
 
 
-- 18. Find categories that have more than 5 products. 
SELECT CategoryName FROM Categories 
WHERE CategoryID IN ( 
SELECT CategoryID FROM Products  
GROUP BY CategoryID 
HAVING COUNT(*) > 5  
); 
 
-- 19. Show customers who have placed more than 3 orders. 
     
select Name, Email from customers  
where customerID IN ( 
select customerID  
from Orders GROUP BY CustomerID  
HAVING COUNT(OrderID) > 3 
); 
 
 -- 20. List the names of customers who gave a 5-star review. 
Select name from customers  
where customerID IN ( 
select customerID FROM Reviews  
WHERE Rating = 5 
);  
         
 
-- • DATE FUNCTIONS 
-- 21. Find all orders placed in the last 300 days. 
select OrderDate  
from orders  
wHERE datediff(curdate(),OrderDate) <=300; 
 
-- 22. List products ordered in the July 2026.  
SELECT OrderDate FROM Orders  
WHERE monthname(OrderDate) = 'July'  
&& year(OrderDate) = 2026; 
 
-- 23. Show the delivery time (in days) for each order. 
SELECT Orders.orderdate, shipping.DeliveryDate,  
DATEDIFF(Shipping.DeliveryDate, Orders.OrderDate)  
AS Delivery_Time_Days 
FROM Orders 
JOIN Shipping ON Orders.OrderID = Shipping.OrderID; 
 
-- 24. Count orders per month. 
select month(OrderDate) AS MonthNumber,  
COUNT(*) AS OrderCount 
FROM Orders 
GROUP BY MONTH(OrderDate) 
ORDER BY MonthNumber ASC; 
 
-- 25. Find how many orders were placed on weekends. 
select case  
when dayname(OrderDate) in (1,7) then 'Weekend' 
else 'Weekday' 
end as Dayy, 
count(*) as Order_Count 
from orders 
group by Dayy; 

-- 26. Show orders that took more than 5 days to deliver. 
select Orders.orderDate, shipping.DeliveryDate,  
datediff(Orders.orderDate,shipping.DeliveryDate) as Date_450  
from orders 
Join shipping on orders.OrderID= shipping.OrderID  
where datediff(Orders.orderDate,shipping.DeliveryDate)  >=450;  
 
-- 27. Find customers who placed orders only in the 2nd quater. 
select customers.name, orders.OrderDate,  
quarter(orders.orderDate) 
as quater_number from customers  
join orders on customers.CustomerID = orders.CustomerID 
where quarter(orders.orderDate)= 2 ;  
 
-- 28. Find total count per Quarter of orders. 
select quater(orderDate) AS Quarter_Number, 
count(*) AS Total_Orders 
from orders 
group by Quarter_Number 
order by Quarter_Number;  
 
-- 29. Show Order per week. 
select dayofweek(OrderDate) as Day_of_week ,  
DAYNAME(OrderDate) as MonthName, 
count(*) as orders 
from orders 
group by Day_of_week, MonthName 
order by Day_of_week ASC; 
 
-- 28. Show total orders per week for the last 6 months. 
Select WEEK(OrderDate) AS WeekNumber, 
count(*) AS TotalOrders 
FROM Orders 
WHERE OrderDate >= curdate() – interval 6 month 
GROUP BY WeekNumber 
ORDER BY WeekNumber; 
 
-- 29. Show all orders placed in the current month. 
SELECT * 
FROM Orders 
WHERE MONTH(OrderDate) = MONTH(CURDATE()) 
AND YEAR(OrderDate) = YEAR(CURDATE()); 
 
 
-- 30. Show all orders placed yesterday. 
SELECT * 
FROM Orders 
WHERE OrderDate = CURDATE() - INTERVAL 1 DAY; 

-- • AGGREGATE FUNCTIONS + GROUP BY + HAVING 
-- 31. Count how many products are in each category. 
select categories.CategoryName, 
count(products.ProductID) as Total_Products_Sold 
from categories  
join products on categories.CategoryID = products.CategoryID 
group by categories.CategoryName; 
 
-- 32. Total orders placed by each customer 
select customerID, count(OrderID) as TotalOrders 
from orders 
group by CustomerID;  
 
-- 33. Customers who placed more than 3 orders. 
select customerID, count(OrderID) AS TotalOrders 
from Orders 
GROUP BY CustomerID 
having COUNT(OrderID) > 3;  
 
-- 34. Total revenue (price × quantity) per category. 
SELECT Categories.CategoryName, 
SUM(Products.Price * OrderDetails.Quantity) AS TotalRevenue 
FROM Orders 
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
JOIN Products ON OrderDetails.ProductID = Products.ProductID 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 
GROUP BY Categories.CategoryName;  
 
-- 35. Categories with total sales over ₹10,000 
SELECT Categories.CategoryName, 
SUM(Products.Price * OrderDetails.Quantity) AS TotalRevenue 
FROM Orders 
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
JOIN Products ON OrderDetails.ProductID = Products.ProductID 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 
GROUP BY Categories.CategoryName 
hAVING TotalSales > 10000;  
 
 
-- 36. Find the average order value per customer. 
SELECT customers.Name, 
AVG(OrderDetails.Quantity * Products.Price) AS AvgOrderValue 
FROM Customers 
JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
JOIN Products ON OrderDetails.ProductID = Products.ProductID 
GROUP BY Customers.Name; 
 
-- 37. Show total revenue generated by each product.  
SELECT Products.Name, 
SUM(OrderDetails.Quantity * Products.Price) AS TotalRevenue 
FROM OrderDetails 
JOIN Products ON OrderDetails.ProductID = Products.ProductID 
GROUP BY Products.Name; 
 
-- 38. List customers who placed more than 5 orders. 
 
SELECT Customers.Name, 
COUNT(Orders.OrderID) AS TotalOrders 
FROM Customers 
JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
GROUP BY Customers.CustomerID, Customers.Name 
HAVING COUNT(Orders.OrderID) > 5; 
 
 
-- 39. Show products with an average rating above 4.0. 
 
 SELECT Products.Name, AVG(Reviews.Rating) AS AvgRating 
 FROM Products 
JOIN Reviews ON Products.ProductID = Reviews.ProductID 
GROUP BY Products.ProductID, Products.Name 
HAVING AVG(Reviews.Rating) > 4; 
 
 
-- 40. Count reviews given per customer. 
 
SELECT Customers.Name,  
COUNT(Reviews.ReviewID) AS TotalReviews 
FROM Customers 
JOIN Reviews ON Customers.CustomerID = Reviews.CustomerID 
GROUP BY Customers.CustomerID, Customers.Name;