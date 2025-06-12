CREATE DATABASE XYZElectronicsDB;

USE XYZElectronicsDB;


CREATE TABLE tblCustomer (
    CustomerID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Address VARCHAR(150),
    Phone VARCHAR(20)
);

CREATE TABLE tblPromotion (
    PromotionID INT AUTO_INCREMENT PRIMARY KEY,
    PromoDescription VARCHAR(255),
    DiscountAmount DECIMAL(5, 2),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE tblProduct (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    PromotionID INT NULL,
    CONSTRAINT FK_Promotion FOREIGN KEY (PromotionID) REFERENCES tblPromotion(PromotionID)
);

CREATE TABLE tblOrder (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentID INT NOT NULL,
    DeliveryID INT NOT NULL,
    CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES tblCustomer(CustomerID),
    CONSTRAINT FK_Payment FOREIGN KEY (PaymentID) REFERENCES tblPayment(PaymentID),
    CONSTRAINT FK_Delivery FOREIGN KEY (DeliveryID) REFERENCES tblDelivery(DeliveryID)
);

CREATE TABLE tblOrderItem (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Order FOREIGN KEY (OrderID) REFERENCES tblOrder(OrderID),
    CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES tblProduct(ProductID)
);


CREATE TABLE tblPayment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    PaymentType VARCHAR(50) NOT NULL CHECK (PaymentType IN ('Online', 'InStore')),
    PaymentStatus VARCHAR(50) CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed'))
);

CREATE TABLE tblDelivery (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    DeliveryType VARCHAR(50) NOT NULL CHECK (DeliveryType IN ('Pickup', 'Delivery')),
    DeliveryDate DATE,
    DeliveryFee DECIMAL(10, 2)
);

CREATE TABLE tblInventory (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Stock INT NOT NULL,
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductID) REFERENCES tblProduct(ProductID)
);

INSERT INTO tblCustomer (Name, Email, Address, Phone)
VALUES 
('Alice Johnson', 'alice.johnson@example.com', '789 Elm St', '555-7890'),
('Michael Brown', 'michael.brown@example.org', '123 Birch St', '555-6543'),
('Emily Davis', 'emily.davis@example.com', '234 Cedar St', '555-3456'),
('David Wilson', 'david.wilson@example.org', '456 Pine St', '555-6789');

INSERT INTO tblProduct (Name, Price, Stock)
VALUES 
('Tablet', 299.99, 100),
('Headphones', 49.99, 200),
('Smartwatch', 199.99, 75),
('Gaming Console', 399.99, 20);

INSERT INTO tblPromotion (PromoDescription, DiscountAmount, StartDate, EndDate)
VALUES 
('Summer Discount', 15.00, '2024-06-01', '2024-09-30'),
('Black Friday Sale', 25.00, '2024-11-25', '2024-11-30'),
('New Year Offer', 20.00, '2024-12-25', '2025-01-10'),
('Back to School', 10.00, '2024-08-01', '2024-09-01');

INSERT INTO tblPayment (PaymentType, PaymentStatus)
VALUES 
('Online', 'Pending'),
('InStore', 'Completed'),
('Online', 'Failed'),
('InStore', 'Completed');

INSERT INTO tblDelivery (DeliveryType, DeliveryDate, DeliveryFee)
VALUES 
('Delivery', '2024-10-18', 7.00),
('Pickup', NULL, 0.00),
('Delivery', '2024-10-19', 8.00),
('Pickup', NULL, 0.00);

INSERT INTO tblOrder (CustomerID, OrderDate, TotalAmount, PaymentID, DeliveryID)
VALUES 
(1, '2024-10-13', 499.99, 1, 1),
(2, '2024-10-14', 299.99, 2, 2),
(3, '2024-10-15', 49.99, 3, 3),
(4, '2024-10-16', 399.99, 4, 4);

INSERT INTO tblOrderItem (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 499.99),
(2, 2, 1, 299.99),
(3, 3, 1, 49.99),
(4, 4, 1, 399.99);



CREATE VIEW vwCustomerOrderHistory AS
SELECT c.Name, o.OrderID, o.OrderDate, o.TotalAmount, p.PaymentType
FROM tblCustomer c
JOIN tblOrder o ON c.CustomerID = o.CustomerID
JOIN tblPayment p ON o.PaymentID = p.PaymentID;

CREATE VIEW vwProductPromotions AS
SELECT p.Name, pr.PromoDescription, pr.DiscountAmount
FROM tblProduct p
JOIN tblPromotion pr ON p.PromotionID = pr.PromotionID;

SELECT * FROM tblCustomer;

SELECT * FROM tblProduct;

SELECT * FROM tblPromotion;

SELECT COUNT(*) AS TotalCustomers FROM tblCustomer;

SELECT * FROM tblProduct WHERE Stock < 20;

SELECT o.OrderID, c.Name AS CustomerName, o.OrderDate, o.TotalAmount
FROM tblOrder o
JOIN tblCustomer c ON o.CustomerID = c.CustomerID;

SELECT p.Name AS ProductName, SUM(oi.Quantity * oi.Price) AS TotalSales
FROM tblOrderItem oi
JOIN tblProduct p ON oi.ProductID = p.ProductID
GROUP BY p.Name;

SELECT o.OrderID, c.Name AS CustomerName, p.PaymentType, p.PaymentStatus, d.DeliveryType, d.DeliveryFee
FROM tblOrder o
JOIN tblCustomer c ON o.CustomerID = c.CustomerID
JOIN tblPayment p ON o.PaymentID = p.PaymentID
JOIN tblDelivery d ON o.DeliveryID = d.DeliveryID;



SELECT o.OrderID, c.Name AS CustomerName, p.PromoDescription, o.TotalAmount, 
       (o.TotalAmount - p.DiscountAmount) AS DiscountedAmount
FROM tblOrder o
JOIN tblCustomer c ON o.CustomerID = c.CustomerID
JOIN tblPromotion p ON o.TotalAmount > p.DiscountAmount;  

