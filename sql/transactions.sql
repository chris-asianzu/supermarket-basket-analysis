CREATE TABLE transactions_temp (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate VARCHAR(255), -- Change this to VARCHAR temporarily
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(100)
);



LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\france_data.csv'
INTO TABLE transactions_temp
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country);

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate VARCHAR(255), -- Temporary VARCHAR for the date
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(100)
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\france_data.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country);



SET SQL_SAFE_UPDATES = 0;

UPDATE transactions
SET InvoiceDate = STR_TO_DATE(REPLACE(InvoiceDate, '/', '-'), '%d-%m-%Y %H:%i')
WHERE InvoiceDate IS NOT NULL;



ALTER TABLE transactions
MODIFY COLUMN InvoiceDate DATETIME;


DELETE FROM transactions
WHERE CustomerID IS NULL;




SELECT Description, SUM(Quantity) AS TotalQuantity
FROM transactions
GROUP BY Description
ORDER BY TotalQuantity DESC
LIMIT 5;




SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM transactions
GROUP BY Country
ORDER BY TotalSales DESC;




SELECT CustomerID, AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM transactions
GROUP BY CustomerID
ORDER BY AverageOrderValue DESC;



