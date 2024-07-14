CREATE SCHEMA drugdatabase;

USE drugdatabase;

CREATE TABLE Bill (
    SSN VARCHAR(11),
    OrderID INT,
    InsurancePay DECIMAL(10, 2),
    CustomerPay DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    PRIMARY KEY (SSN, OrderID),
    FOREIGN KEY (SSN) REFERENCES Customers(SSN),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
)

CREATE TABLE Cancellation (
    CancellationID INT PRIMARY KEY,
    RefundStatus VARCHAR(10)
)

CREATE TABLE Customers (
    InsuranceID INT PRIMARY KEY,
    Name VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    SSN VARCHAR(11), -- Assuming US Social Security Number format (xxx-xx-xxxx)
    Phone VARCHAR(15), -- Assuming a standard phone number format
    Address VARCHAR(255),
    InsuranceID_AlphaNum VARCHAR(20) -- Assuming insurance ID is alphanumeric
)

CREATE TABLE Delivery (
    EmployeeID INT PRIMARY KEY,
    Review TEXT
)
CREATE TABLE Disposal (
    DrugName VARCHAR(100),
    BatchNo VARCHAR(50),
    CompanyName VARCHAR(100),
    DisposalQuantity INT,
    PRIMARY KEY (DrugName, BatchNo),
    FOREIGN KEY (DrugName) REFERENCES Medicine(DrugName),
    FOREIGN KEY (BatchNo) REFERENCES Medicine(BatchNumber)
)

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Phone VARCHAR(15),
    DateOfBirth DATE,
    Salary DECIMAL(10, 2),
    FirstName VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    Role VARCHAR(50),
    LicenseStatus VARCHAR(3),
    SSN VARCHAR(11)
)

CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
    CompanyName VARCHAR(100),
    InsuranceName VARCHAR(100)
)

CREATE TABLE Medicine (
    DrugName VARCHAR(100) PRIMARY KEY,
    MedType VARCHAR(50),
    Manufacturer VARCHAR(100),
    StockQuantity INT,
    ExpiryDate DATE,
    Price DECIMAL(10, 2),
    BatchNumber VARCHAR(50)
)

CREATE TABLE Notification (
    NotificationID INTEGER PRIMARY KEY AUTOINCREMENT,
    Message TEXT
)

CREATE TABLE OrderDrugs (
    Price DECIMAL(10, 2),
    OrderQuantity INT,
    OrderID INT,
    DrugName VARCHAR(100),
    BatchNo VARCHAR(50),
    PRIMARY KEY (OrderID, DrugName, BatchNo),
    FOREIGN KEY (DrugName) REFERENCES PharmaceuticalDetails(DrugName),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BatchNo) REFERENCES Batches(BatchNo)
)

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    PrescriptionID INT,
    EmployeeID INT,
    OrderDate DATE,
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

CREATE TABLE PharmaceuticalDetails (
    PharmaceuticalID INT PRIMARY KEY,
    ManufacturingDetails TEXT,
    Potency VARCHAR(50),
    CompanyName VARCHAR(100)
)

CREATE TABLE Prescription (
    SSN VARCHAR(11),
    PrescriptionID INT PRIMARY KEY,
    DocID INT,
    PrescriptionDate DATE,
    FOREIGN KEY (SSN) REFERENCES Customers(SSN),
    FOREIGN KEY (DocID) REFERENCES Doctors(DocID)
)

CREATE TABLE PrescriptionDrug (
    DrugName VARCHAR(100),
    PrescriptionID INT,
    PrescriptionQuantity INT,
    RefillLimit INT,
    PRIMARY KEY (DrugName, PrescriptionID),
    FOREIGN KEY (DrugName) REFERENCES PharmaceuticalDetails(DrugName),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
)

CREATE TABLE PreviousMedicalRecords (
    RecordID INT PRIMARY KEY,
    RecordDate DATE,
    Diagnosis TEXT
)






DELIMITER //

CREATE TRIGGER updatetime BEFORE INSERT ON orders FOR EACH ROW
BEGIN
    SET NEW.orderdatetime = NOW();
END//

DELIMITER ;



DELIMITER //
CREATE TRIGGER inventorytrigger AFTER INSERT ON orders
FOR EACH ROW
begin

DECLARE qnty int;
DECLARE productid varchar(20);

SELECT   pid INTO productid
FROM      orders
ORDER BY  oid DESC
LIMIT     1;

SELECT   quantity INTO qnty 
FROM      orders
ORDER BY  oid DESC
LIMIT     1;

UPDATE inventory
SET quantity=quantity-qnty
WHERE pid=productid;
END//

DELIMITER ;





DELIMITER //

CREATE PROCEDURE getsellerorders(IN param1 VARCHAR(20))
BEGIN
    SELECT *  FROM orders where sid=param1;
END //
 
DELIMITER ;



DELIMITER //

CREATE PROCEDURE getorders
(IN param1 VARCHAR(20))
BEGIN
   SELECT * FROM orders WHERE uid=param1;
END //

DELIMITER ;
