use couriermanagementsystem;
show tables;


-- Inserting 5 sample records into User Table
INSERT INTO `User Table` (Name, Email, Password, ContactNumber, Address) 
VALUES 
('John Doe', 'johndoe@example.com', 'password123', '1234567890', '123 Main Street'),
('Alice Smith', 'alicesmith@example.com', 'securepass', '9876543210', '456 Elm Street'),
('Mary Johnson', 'maryjohnson@example.com', 'pass123', '4567890123', '789 Oak Avenue'),
('David Lee', 'davidlee@example.com', 'davidpass', '7890123456', '1010 Maple Lane'),
('Emily Brown', 'emilybrown@example.com', 'emilypass', '8901234567', '1234 Pine Road');

-- Inserting 5 sample records into Courier Table
INSERT INTO Courier (SenderName, SenderAddress, ReceiverName, ReceiverAddress, Weight, Status, TrackingNumber, DeliveryDate)
VALUES 
('Jane Doe', '456 Oak Street', 'Bob Smith', '789 Maple Avenue', 3.5, 'In Transit', '1234567890', '2024-03-10 12:00:00'),
('Samantha Johnson', '789 Pine Road', 'Michael Williams', '1010 Cedar Lane', 2.0, 'Delivered', '9876543210', '2024-03-08 15:30:00'),
('Alice Jones', '111 Elm Street', 'Tom Brown', '222 Oak Avenue', 1.8, 'In Transit', '2468135790', '2024-03-09 10:00:00'),
('Robert Smith', '333 Pine Road', 'Emma Davis', '444 Maple Lane', 4.2, 'Shipped', '1357924680', '2024-03-11 14:45:00'),
('Linda Wilson', '555 Cedar Lane', 'Kevin Johnson', '666 Elm Street', 2.5, 'Delivered', '8024681357', '2024-03-07 17:20:00');

-- Inserting 5 sample records into Employee Table
INSERT INTO Employee_Table (Name, Email, ContactNumber, Role, Salary, `User Table_UserID`)
VALUES 
('Emily Brown', 'emilybrown@example.com', '2345678901', 'Manager', 50000.00, 1),
('Robert Lee', 'robertlee@example.com', '3456789012', 'Courier', 40000.00, 2),
('Sarah Davis', 'sarahdavis@example.com', '4567890123', 'Manager', 55000.00, 3),
('Michael Wilson', 'michaelwilson@example.com', '5678901234', 'Courier', 42000.00, 4),
('Jessica Clark', 'jessicaclark@example.com', '6789012345', 'Courier', 41000.00, 5);

-- Inserting 5 sample records into Location Table
INSERT INTO Location_Table (LocationName, Address, Employee_Table_EmployeeID)
VALUES 
('Main Office', '123 Main Street', 1),
('Warehouse', '789 Pine Road', 2),
('Branch Office', '456 Elm Street', 3),
('Distribution Center', '1010 Maple Lane', 4),
('Storage Facility', '789 Oak Avenue', 5);

-- Inserting 5 sample records into CourierServices Table
INSERT INTO CourierServices (ServiceName, Cost, Courier_CourierID)
VALUES 
('Express Delivery', 10.00, 1),
('Standard Delivery', 5.00, 2),
('Same-day Delivery', 15.00, 3),
('International Shipping', 20.00, 4),
('Local Delivery', 7.00, 5);

-- Inserting 5 sample records into Payment Table
INSERT INTO Payment_Table (CourierID, LocationId, Amount, PaymentDate, Location_Table_LocationID, CourierServices_ServiceID)
VALUES 
(1, 1, 15.00, '2024-03-10 14:00:00', 1, 1),
(2, 2, 7.50, '2024-03-08 16:00:00', 2, 2),
(3, 3, 20.00, '2024-03-09 11:30:00', 3, 3),
(4, 4, 25.00, '2024-03-11 15:00:00', 4, 4),
(5, 5, 10.00, '2024-03-07 18:00:00', 5, 5);

SELECT *
FROM `User Table`;



SELECT *
FROM Courier c
JOIN `User Table` u ON c.SenderName = u.Name
WHERE u.UserID = 1;



SELECT *
FROM Courier;


SELECT *
FROM Courier
WHERE TrackingNumber = '8024681357';


SELECT *
FROM Courier
WHERE CourierID = 1;
SELECT *
FROM Courier
WHERE Status <> 'Delivered';


SELECT *
FROM Courier
WHERE DATE(DeliveryDate) = CURDATE();

SELECT *
FROM Courier
WHERE Status = 'In Transit';
SELECT CourierID, COUNT(*) AS TotalPackages
FROM Courier
GROUP BY CourierID;


SELECT *
FROM Courier
WHERE Weight BETWEEN 5 AND 10;

SELECT *
FROM Employee_Table
WHERE Name LIKE '%John%';
SELECT c.*
FROM Courier c
JOIN Payment_Table p ON c.CourierID = p.CourierID
WHERE p.Amount > 50;
SELECT l.LocationID, l.LocationName, SUM(p.Amount) AS TotalRevenue
FROM Location_Table l
LEFT JOIN Payment_Table p ON l.LocationID = p.LocationID
GROUP BY l.LocationID, l.LocationName;





SELECT LocationID, SUM(Amount) AS TotalPayments
FROM Payment_Table
GROUP BY LocationID
HAVING TotalPayments < 45;



SELECT LocationID, SUM(Amount) AS TotalPayments
FROM Payment_Table
GROUP BY LocationID;

SELECT c.CourierID, SUM(p.Amount) AS TotalPayments
FROM Courier c
JOIN Payment_Table p ON c.CourierID = p.CourierID
WHERE p.LocationID = 4
GROUP BY c.CourierID
HAVING TotalPayments > 1000;
SELECT LocationID, SUM(Amount) AS TotalPayments
FROM Payment_Table
WHERE PaymentDate > 'YYYY-MM-DD'
GROUP BY LocationID
HAVING TotalPayments > 5000;



SELECT p.PaymentID, p.Amount, p.PaymentDate, c.CourierID, c.SenderName, c.ReceiverName
FROM Payment_Table p
JOIN Courier c ON p.CourierID = c.CourierID;
SELECT p.PaymentID, p.Amount, p.PaymentDate, l.LocationID, l.LocationName
FROM Payment_Table p
JOIN Location_Table l ON p.LocationID = l.LocationID;
SELECT p.PaymentID, p.Amount, p.PaymentDate, c.CourierID, c.SenderName, c.ReceiverName, l.LocationID, l.LocationName
FROM Payment_Table p
JOIN Courier c ON p.CourierID = c.CourierID
JOIN Location_Table l ON p.LocationID = l.LocationID;
SELECT c.CourierID, c.SenderName, c.ReceiverName, SUM(p.Amount) AS TotalPaymentsReceived
FROM Courier c
JOIN Payment_Table p ON c.CourierID = p.CourierID
GROUP BY c.CourierID, c.SenderName, c.ReceiverName;
SELECT *
FROM Payment_Table
WHERE PaymentDate = '2024-03-01';



SELECT p.PaymentID, p.Amount, p.PaymentDate, c.CourierID, c.SenderName, c.ReceiverName
FROM Payment_Table p
LEFT JOIN Courier c ON p.CourierID = c.CourierID;


SELECT p.PaymentID, p.Amount, p.PaymentDate, l.LocationID, l.LocationName
FROM Payment_Table p
LEFT JOIN Location_Table l ON p.LocationID = l.LocationID;


SELECT c.CourierID, c.SenderName, c.ReceiverName, SUM(p.Amount) AS TotalPayments
FROM Courier c
LEFT JOIN Payment_Table p ON c.CourierID = p.CourierID
GROUP BY c.CourierID, c.SenderName, c.ReceiverName;


SELECT *
FROM Payment_Table
WHERE PaymentDate BETWEEN '2024-01-01' AND '2024-03-01';



SELECT Role, GROUP_CONCAT(Name) AS Employees
FROM Employee_Table
GROUP BY Role
HAVING COUNT(*) > 1;
SELECT p.*
FROM Payment_Table p
JOIN Courier c ON p.CourierID = c.CourierID
JOIN (
    SELECT SenderAddress, COUNT(*) AS CourierCount
    FROM Courier
    GROUP BY SenderAddress
    HAVING CourierCount > 1
) AS multiple_couriers ON c.SenderAddress = multiple_couriers.SenderAddress;



SELECT *
FROM Courier
WHERE Weight > (SELECT AVG(Weight) FROM Courier);

SELECT Name
FROM Employee_Table
WHERE Salary > (SELECT AVG(Salary) FROM Employee_Table);
SELECT SUM(Cost) AS TotalCost
FROM CourierServices
WHERE Cost < (SELECT MAX(Cost) FROM CourierServices);
SELECT DISTINCT c.*
FROM Courier c
INNER JOIN Payment_Table p ON c.CourierID = p.CourierID;
SELECT *
FROM Courier
WHERE SenderName = 'SenderName' AND Weight > ALL (SELECT Weight FROM Courier WHERE SenderName = 'SenderName');
