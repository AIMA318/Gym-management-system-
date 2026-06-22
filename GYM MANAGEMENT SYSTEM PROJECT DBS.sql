CREATE DATABASE GymDBSM;
USE GymDBSM;

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    JoinDate DATE,
    MembershipType VARCHAR(20),
    TrainerID INT
);

CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Specialty VARCHAR(50)
);
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    MemberID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    MemberID INT,
    Date DATE,
    Status VARCHAR(10),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
CREATE TABLE DietPlans (
    DietID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    Goal VARCHAR(30),
    Calories INT,
    ProteinGrams INT,
    CarbsGrams INT,
    FatsGrams INT
);
CREATE TABLE MemberDiet (
    ID INT PRIMARY KEY,
    MemberID INT,
    DietID INT,
    StartDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (DietID) REFERENCES DietPlans(DietID)
);
INSERT INTO Trainers VALUES
(1, 'Ali Trainer', 'Fitness'),
(2, 'Usman Coach', 'Weight Loss'),
(3, 'Sara Trainer', 'Muscle Gain');


INSERT INTO Members VALUES
(1, 'Ahmed', '03001234567', GETDATE(), 'Monthly', 1),
(2, 'Sara', '03111234567', GETDATE(), 'Yearly', 2),
(3, 'Bilal', '03221234567', GETDATE(), 'Monthly', 1),
(4, 'Ayesha', '03331234567', GETDATE(), 'Quarterly', 3);


INSERT INTO Payments VALUES
(1, 1, 5000, GETDATE()),
(2, 2, 12000, GETDATE()),
(3, 3, 5000, GETDATE()),
(4, 4, 8000, GETDATE());


INSERT INTO Attendance VALUES
(1, 1, GETDATE(), 'Present'),
(2, 2, GETDATE(), 'Absent'),
(3, 3, GETDATE(), 'Present'),
(4, 4, GETDATE(), 'Present');

INSERT INTO DietPlans VALUES
(1, 'Basic Fitness', 'General', 2000, 100, 250, 70),
(2, 'Weight Loss Plan', 'Weight Loss', 1500, 120, 150, 50),
(3, 'Muscle Gain Plan', 'Muscle Gain', 3000, 200, 350, 90);

INSERT INTO MemberDiet VALUES
(1, 1, 1, GETDATE()),
(2, 2, 2, GETDATE()),
(3, 3, 3, GETDATE()),
(4, 4, 1, GETDATE());

UPDATE Members
SET MembershipType = 'Yearly'
WHERE MemberID = 1;


DELETE FROM Payments
WHERE PaymentID = 2;

DELETE FROM Members
WHERE MemberID = 2;

DELETE FROM Attendance
WHERE AttendanceID= 2;

DELETE FROM Trainers
WHERE TrainerID = 2;

SELECT * FROM Members;
SELECT * FROM Trainers;
SELECT * FROM Payments;
SELECT * FROM Attendance;
SELECT * FROM DietPlans;

SELECT SUM(Amount) AS TotalRevenue
FROM Payments;

SELECT AVG(Amount) AS AveragePayment
FROM Payments;

SELECT COUNT(*) AS TotalMembers
FROM Members;

SELECT MAX(Amount) AS HighestPayment
FROM Payments;

SELECT MemberID, SUM(Amount) AS TotalPayment
FROM Payments
GROUP BY MemberID;

SELECT MemberID, SUM(Amount) AS TotalPayment
FROM Payments
GROUP BY MemberID
HAVING SUM(Amount) > 5000;

IF OBJECT_ID('AddMember', 'P') IS NOT NULL
    DROP PROCEDURE AddMember;
GO

CREATE PROCEDURE AddMember
    @ID INT,
    @Name VARCHAR(50),
    @Phone VARCHAR(15),
    @Type VARCHAR(20),
    @TrainerID INT
AS
BEGIN
    INSERT INTO Members
    VALUES (@ID, @Name, @Phone, GETDATE(), @Type, @TrainerID);
END;
GO


IF OBJECT_ID('AddPayment', 'P') IS NOT NULL
    DROP PROCEDURE AddPayment;
GO

CREATE PROCEDURE AddPayment
    @PaymentID INT,
    @MemberID INT,
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Payments
    VALUES (@PaymentID, @MemberID, @Amount, GETDATE());
END;
GO

EXEC AddPayment 5, 1, 6000;
INSERT INTO Payments VALUES (10, 1, -500, GETDATE());

IF OBJECT_ID('GetTotalPayment', 'FN') IS NOT NULL
    DROP FUNCTION GetTotalPayment;
GO

CREATE FUNCTION GetTotalPayment (@MemberID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = SUM(Amount)
    FROM Payments
    WHERE MemberID = @MemberID;

    RETURN ISNULL(@Total, 0);
END;
GO

IF OBJECT_ID('GetMembershipDays', 'FN') IS NOT NULL
    DROP FUNCTION GetMembershipDays;
GO

CREATE FUNCTION GetMembershipDays (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Days INT;

    SELECT @Days = DATEDIFF(DAY, JoinDate, GETDATE())
    FROM Members
    WHERE MemberID = @MemberID;

    RETURN @Days;
END;
GO

IF OBJECT_ID('GetMemberDiet', 'FN') IS NOT NULL
    DROP FUNCTION GetMemberDiet;
GO

CREATE FUNCTION GetMemberDiet (@MemberID INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @DietName VARCHAR(50);

    SELECT @DietName = DP.PlanName
    FROM MemberDiet MD
    JOIN DietPlans DP ON MD.DietID = DP.DietID
    WHERE MD.MemberID = @MemberID;

    RETURN ISNULL(@DietName, 'No Diet Assigned');
END;
GO

SELECT dbo.GetTotalPayment(1);
SELECT dbo.GetMembershipDays(1);
SELECT dbo.GetMemberDiet(1);

SELECT MemberID, SUM(Amount) AS TotalPayment
FROM Payments
GROUP BY MemberID;

SELECT * FROM Members
ORDER BY Name ASC;

SELECT * FROM Payments
ORDER BY Amount DESC;

SELECT M.Name, P.Amount
FROM Members M
INNER JOIN Payments P ON M.MemberID = P.MemberID;

SELECT M.Name, P.Amount
FROM Members M
LEFT JOIN Payments P ON M.MemberID = P.MemberID;

SELECT M.Name, DP.PlanName
FROM Members M
JOIN MemberDiet MD ON M.MemberID = MD.MemberID
JOIN DietPlans DP ON MD.DietID = DP.DietID;

SELECT M.Name, T.Name AS TrainerName
FROM Members M
JOIN Trainers T ON M.TrainerID = T.TrainerID;

IF OBJECT_ID('AddMember', 'P') IS NOT NULL
    DROP PROCEDURE AddMember;
GO

CREATE PROCEDURE AddMember
    @ID INT,
    @Name VARCHAR(50),
    @Phone VARCHAR(15),
    @Type VARCHAR(20),
    @TrainerID INT
AS
BEGIN
    INSERT INTO Members
    VALUES (@ID, @Name, @Phone, GETDATE(), @Type, @TrainerID);
END;
GO

IF OBJECT_ID('AddPayment', 'P') IS NOT NULL
    DROP PROCEDURE AddPayment;
GO

CREATE PROCEDURE AddPayment
    @PaymentID INT,
    @MemberID INT,
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Payments
    VALUES (@PaymentID, @MemberID, @Amount, GETDATE());
END;
GO

IF OBJECT_ID('MemberPayments', 'V') IS NOT NULL
    DROP VIEW MemberPayments;
GO

CREATE VIEW MemberPayments AS
SELECT M.Name, P.Amount, P.PaymentDate
FROM Members M
JOIN Payments P ON M.MemberID = P.MemberID;
GO

IF OBJECT_ID('MemberDietView', 'V') IS NOT NULL
    DROP VIEW MemberDietView;
GO

CREATE VIEW MemberDietView AS
SELECT M.Name, DP.PlanName
FROM Members M
JOIN MemberDiet MD ON M.MemberID = MD.MemberID
JOIN DietPlans DP ON MD.DietID = DP.DietID;
GO

SELECT * FROM MemberPayments;
SELECT * FROM MemberDietView;

EXEC AddMember 10, 'Hamza', '03451234567', 'Monthly', 1;
EXEC AddPayment 10, 1, 7000;

IF OBJECT_ID('trg_NoNegativePayment', 'TR') IS NOT NULL
    DROP TRIGGER trg_NoNegativePayment;
GO

CREATE TRIGGER trg_NoNegativePayment
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Amount < 0)
    BEGIN
        PRINT 'Payment cannot be negative';
    END
    ELSE
    BEGIN
        INSERT INTO Payments (PaymentID, MemberID, Amount, PaymentDate)
        SELECT PaymentID, MemberID, Amount, PaymentDate
        FROM inserted;
    END
END;
GO
INSERT INTO Payments VALUES (10, 1, -500, GETDATE());

