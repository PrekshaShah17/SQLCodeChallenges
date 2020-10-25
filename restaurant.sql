-- 1. create table inventory for a party

SELECT DISTINCT CustomerID, FirstName, LastName, Email, Address
FROM Customers
ORDER BY LastName
;

-- 2. create a table to store information

CREATE TABLE IF NOT EXISTS PartyAttendees
(
    "CustomerID" INT
    , "PartySize" INT
    , FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)
;

-- 3. print a menu

-- 3.1 Menu 1
SELECT *
FROM Dishes
ORDER BY Price
;

-- 3.2 Menu 2
SELECT *
FROM Dishes
WHERE Type IN ('Appetizer', 'Beverage')
ORDER BY Type
;

-- 3.3 Menu 3
SELECT *
FROM Dishes
WHERE Type <> 'Beverage'
ORDER BY Type
;

-- 4. Sign a customer up for loyalty program

INSERT INTO Customers (FirstName, LastName, Email, Address, City, State, Phone, Birthday, FavoriteDish)
VALUES ('John', 'Doe', 'john.doe@gmail.com', '1111 I dont know street, Atlantis', '', '', 0000, '200BC', 'Water')
;

-- 5. Update a customer's personal information'

UPDATE Customers SET
    Address = '1111 Center Island'
    , City = 'Donana'
    , State = 'Atlantis'
WHERE CustomerID = 21
;

SELECT * FROM Customers
WHERE CustomerID = 21
;

-- 6. Remove customer's record

DELETE FROM Customers
WHERE CustomerID = 101
;

-- 7. Log customer responses

INSERT INTO PartyAttendees
    SELECT CustomerID, 4
    FROM Customers
    WHERE Email = "hpughek@orangevalleycaa.org"
;

SELECT * FROM Reservations;

-- 8. Look up reservations

SELECT FirstName, LastName, Date
FROM Reservations
    JOIN Customers C
    on Reservations.CustomerID = C.CustomerID
WHERE LOWER(LastName) LIKE 'ste%son'
    AND date(datetime(Date)) = '2020-06-14'
;

-- 9. Take a reservation

SELECT * FROM Customers
WHERE LastName LIKE '%Adam%'
;

INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES ('Sam', 'McAdams', 'smac@rouxacademy.com', 5555551212)
;

INSERT INTO Reservations (ReservationID, CustomerID, Date, PartySize)
SELECT max_id, 102, '2020-07-14 06:00:00', 5
FROM (SELECT MAX(ReservationID) AS max_id FROM Reservations)
;

SELECT * FROM Reservations WHERE CustomerID = 102;

-- 10. Take an order

SELECT * FROM Customers WHERE FirstName LIKE '%Loretta%'; -- 70 (custid)

SELECT * FROM Dishes WHERE LOWER(Name) LIKE '%house salad%'
                            OR LOWER(Name) LIKE '%mini cheese%'
                            OR LOWER(Name) LIKE '%blue smoothie%'; --4, 7, 20 (dishid)

INSERT INTO Orders
SELECT max_id+1, 70, '2020-06-24'
FROM (SELECT MAX(OrderID) AS max_id FROM Orders)
;

SELECT * FROM Orders WHERE CustomerID = 70;

INSERT INTO OrdersDishes
SELECT max_id+1, 1001, 4
FROM (SELECT MAX(OrdersDishesID) AS max_id FROM OrdersDishes)
;

INSERT INTO OrdersDishes
SELECT max_id+1, 1001, 7
FROM (SELECT MAX(OrdersDishesID) AS max_id FROM OrdersDishes)
;

INSERT INTO OrdersDishes
SELECT max_id+1, 1001, 20
FROM (SELECT MAX(OrdersDishesID) AS max_id FROM OrdersDishes)
;

SELECT SUM(Price) AS Total
FROM OrdersDishes JOIN Dishes D on OrdersDishes.DishID = D.DishID
WHERE OrderID = 1001
;

-- 11. Track your customer's favorite dish

UPDATE Customers
SET FavoriteDish = (SELECT DishID
                    FROM Dishes
                    WHERE Name = 'Quinoa Salmon Salad')
WHERE CustomerID = 42
;

SELECT FirstName, LastName, FavoriteDish, Name
FROM Customers c
    JOIN Dishes d ON c.FavoriteDish = d.DishID
WHERE CustomerID = 42;

-- 12. Prepare a report of your top 5 customers

SELECT FirstName, LastName, Email
     , SUM(Price) as TotalBusiness
     , COUNT(O.OrderID) AS TotalOrders
FROM Customers
    JOIN Orders O on Customers.CustomerID = O.CustomerID
    JOIN OrdersDishes OD on O.OrderID = OD.OrderID
    JOIN Dishes D on OD.DishID = D.DishID
GROUP BY FirstName, LastName
ORDER BY TotalBusiness DESC
LIMIT 5
;