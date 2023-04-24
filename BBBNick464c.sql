GO
USE master
GO

IF DB_ID('BBBNick464c') IS NOT NULL
	BEGIN
	ALTER DATABASE BBBNick464c SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE BBBNick464c
	END

CREATE DATABASE BBBNick464c

GO
USE BBBNick464c
GO

DROP TABLE IF EXISTS Vaskerier
CREATE TABLE Vaskerier(
VaskeriId INT IDENTITY(1,1) PRIMARY KEY,
Navn VARCHAR(50),
Åben TIME,
Luk TIME
)

DROP TABLE IF EXISTS Brugere
CREATE TABLE Brugere (
BrugerId INT IDENTITY(1,1) PRIMARY KEY,
Navn VARCHAR(50),
Email VARCHAR(50) UNIQUE,
[Password] VARCHAR (50) CHECK (LEN(password) >= 5),
Konto DECIMAL,
VaskeriId INT FOREIGN KEY REFERENCES Vaskerier(VaskeriId),
Oprettelse DATETIME,
)

DROP TABLE IF EXISTS Maskiner
CREATE TABLE Maskiner(
MaskineId INT IDENTITY(1,1) PRIMARY KEY,
Navn VARCHAR(50),
Pris DECIMAL,
Tid INT,
VaskeriId INT FOREIGN KEY REFERENCES Vaskerier(VaskeriId)
)

DROP TABLE IF EXISTS Bookinger
CREATE TABLE Bookinger(
BookId INT IDENTITY(1,1) PRIMARY KEY,
Bestilling DATETIME,
BrugerId INT FOREIGN KEY REFERENCES Brugere(BrugerId),
MaskineId INT FOREIGN KEY REFERENCES Maskiner(MaskineId)
)

INSERT INTO Vaskerier(Navn, Åben, Luk) VALUES ('Whitewash Inc', '08:00' , '20:00')
INSERT INTO Vaskerier(Navn, Åben, Luk) VALUES ('Double Bubble', '02:00' , '22:00')
INSERT INTO Vaskerier(Navn, Åben, Luk) VALUES ('Wash & Coffee', '12:00' , '20:00')

INSERT INTO Brugere (Navn, Email, [Password], Konto, VaskeriId, Oprettelse) VALUES ('John', 'john_doe66@gmail.com', 'password', 100.00, 2, '2021-02-15')
INSERT INTO Brugere (Navn, Email, [Password], Konto, VaskeriId, Oprettelse) VALUES ('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, '2021-02-10')
INSERT INTO Brugere (Navn, Email, [Password], Konto, VaskeriId, Oprettelse) VALUES ('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, '2020-03-10')
INSERT INTO Brugere (Navn, Email, [Password], Konto, VaskeriId, Oprettelse) VALUES ('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecongnized', 100000.00, 1, '2021-01-01')
INSERT INTO Brugere (Navn, Email, [Password], Konto, VaskeriId, Oprettelse) VALUES ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, '2020-07-06')

INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('Mielle 911 Turbo', 5.00, 60, 2)
INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('Siemons IClean', 10000.00, 30, 1)
INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('Electrolax FX-2', 15.00, 45, 2)
INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('NASA Spacewasher 8000', 500.00, 5, 1)
INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('The Lost Sock', 3.50, 90, 3)
INSERT INTO Maskiner (Navn, Pris, Tid, VaskeriId) VALUES ('Yo Mama', 0.50, 120, 3)

INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 12:00:00', 1, 1)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 16:00:00', 1, 3)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 08:00:00', 2, 4)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 15:00:00', 3, 5)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 20:00:00', 4, 2)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 19:00:00', 4, 2)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 10:00:00', 4, 2)
INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2021-02-26 16:00:00', 5, 6)

INSERT INTO Bookinger (Bestilling, BrugerId, MaskineId) VALUES ('2023-02-02 12:00:00', 4, 2)
BEGIN TRANSACTION
UPDATE Brugere SET Konto = 90000 WHERE Navn = 'Goldman Sachs'
COMMIT TRANSACTION


GO
CREATE VIEW vw_Bookinger 
AS
SELECT b.Bestilling, u.Navn AS BrugerNavn, m.Navn AS MaskineNavn, m.Pris
FROM Bookinger b
INNER JOIN Brugere u ON b.BrugerId = u.BrugerId
INNER JOIN Maskiner m ON b.MaskineId = m.MaskineId
GO

SELECT * FROM vw_Bookinger

SELECT * FROM Brugere WHERE Email LIKE '%@gmail.com'

SELECT Maskiner.Navn AS 'Maskine Navn', Vaskerier.Navn AS 'Vaskeri Navn', Vaskerier.Åben AS 'Vaskeri Åbenings tid', Vaskerier.Luk AS 'Vaskeri Luknings Tid'
FROM Maskiner
JOIN Vaskerier
ON Maskiner.VaskeriId = Vaskerier.VaskeriId

SELECT MaskineId, COUNT(MaskineId) AS BookingCount
FROM Bookinger
GROUP BY MaskineId

DELETE FROM Bookinger WHERE CAST(Bestilling AS TIME) BETWEEN '12:00:00' AND '13:00:00'

UPDATE Brugere SET Password = 'SelinaKyle' Where Navn = 'Batman'
