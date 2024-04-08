SELECT * 
FROM Product
WHERE Color= 'Blue'
--3
SELECT ProductID,LocationID,Quantity
FROM ProductInventory
WHERE LocationID = 7 AND Quantity > 250
ORDER BY Quantity DESC
--4 
SELECT B.ProductID,B.Name AS'ProductName',B.Color,B.Cost,
		B.Price,A.LocationID,C.Name AS 'LocationName',A.Shelf,A.Bin,A.Quantity
FROM ProductInventory A
FULL JOIN Product B ON A.ProductID = B.ProductID
FULL JOIN Location C ON A.LocationID = C.LocationID
WHERE (B.Color LIKE 'Yellow') and (B.Cost < 400)

SELECT A.ProductID,A.Name,A.Color,A.Cost,A.Price,B.LocationID,C.Name,B.Bin,B.Shelf,B.Quantity
FROM Product A
LEFT JOIN ProductInventory B ON A.ProductID = B.ProductID
LEFT JOIN Location C ON B.LocationID = C.LocationID
WHERE (A.Color LIKE 'Yellow') and (A.Cost < 400 )


--5
SELECT A.ModelID,A.Name AS 'ModelName',COUNT(B.ProductID) AS 'NumberOfProducts'
FROM ProductModel A
LEFT JOIN Product B ON A.ModelID = B.ModelID
GROUP BY A.ModelID,A.Name
HAVING (A.Name LIKE 'Mountain%') OR (A.Name LIKE 'ML Mountain%')
ORDER BY COUNT(B.ProductID) DESC, A.Name ASC

SELECT P.ModelID , M.Name,COUNT( P.ProductID) as NumberOfProducts
FROM Product P, ProductModel M
WHERE P.ModelID = M.ModelID and ( M.Name like 'Mountain%' or M.Name like 'ML Mountain%')
GROUP BY P.ModelID, M.Name
HAVING COUNT( P.ProductID) >= 0
ORDER BY NumberOfProducts DESC, M.Name ASC

--6
SELECT A.ProductID,A.Name,SUM(B.Quantity) AS 'TotalQuantity'
FROM Product A
LEFT JOIN ProductInventory B ON A.ProductID = B.ProductID
GROUP BY A.ProductID,A.Name
HAVING SUM(B.Quantity) IN ( 
SELECT MAX(T.TotalQuantity)
FROM (SELECT SUM(B.Quantity) AS 'TotalQuantity'
FROM Product A
LEFT JOIN ProductInventory B ON A.ProductID = B.ProductID
GROUP BY A.ProductID,A.Name) T )

SELECT I.ProductID, P.Name, SUM(I.Quantity) AS TotalQuantity
FROM Product P, ProductInventory I
WHERE P.ProductID = I.ProductID 
GROUP BY I.ProductID, P.Name
HAVING SUM(I.Quantity) = (SELECT TOP 1 SUM(I.Quantity) AS TotalQuantity
FROM Product P, ProductInventory I
WHERE P.ProductID = I.ProductID 
GROUP BY I.ProductID, P.Name
ORDER BY TotalQuantity DESC)

--7
SELECT R.LocationID,R.LocationName,R.ProductID,R.ProductName,R.Quantity
FROM (
SELECT A.LocationID,C.Name AS 'LocationName', B.ProductID,B.Name AS 'ProductName',A.Quantity,
			RANK() OVER (PARTITION BY A.LocationID ORDER BY A.Quantity DESC) AS T 
FROM ProductInventory A 
LEFT JOIN Product B ON A.ProductID = B.ProductID
INNER JOIN Location C ON A.LocationID = C.LocationID) AS R
WHERE R.T = 1 
ORDER BY R.LocationName ASC,R.ProductName DESC

SELECT I.LocationID, L.Name AS LocationName, I.ProductID, P.Name as ProductName, I.Quantity 
FROM Product P, ProductInventory I,Location L
WHERE P.ProductID = I.ProductID AND I.LocationID = L.LocationID
AND I.Quantity IN (SELECT MAX (A.Quantity) FROM
(
SELECT L.Name, I.Quantity
FROM ProductInventory I ,Location L
WHERE I.LocationID = L.LocationID
GROUP BY L.Name, I.Quantity) AS A
GROUP BY A.Name)
GROUP BY I.LocationID, L.Name,I.ProductID, P.Name,I.Quantity 
ORDER BY P.Name DESC, L.Name ASC

--8
drop proc proc_product_quantity 
CREATE PROC proc_product_quantity 
	@productID int ,
	@totalQuantity int OUTPUT
AS
BEGIN
	SET @totalQuantity = ( 
	SELECT SUM(A.Quantity)
	FROM ProductInventory A
	WHERE A.ProductID = @productID
	GROUP BY A.ProductID
	)
END

DECLARE @X INT 
EXEC proc_product_quantity 1,@X OUTPUT
SELECT @X AS 'TotalQuantity'


--9
CREATE TRIGGER tr_insert_Product_Subcategory
on Product instead of insert 
AS
BEGIN 
	SELECT A.ProductID,A.Name AS 'ProductName',A.SubcategoryID,B.Name AS'SubcategoryName',B.Category
FROM inserted A, ProductSubcategory B
	WHERE A.SubcategoryID = B.SubcategoryID
END
INSERT INTO Product(ProductID,Name,Cost,Price,SubcategoryID,SellStartDate)
VALUES (1005,'Product Test',12,15,1,'2021-10-25')
--10
DELETE FROM ProductInventory 
WHERE ProductID IN 
( SELECT A.ProductID
FROM Product A
WHERE A.ModelID = 33 )

--1
--SELECT [ ALL | DISTINCT ]
 --[ TOP n [ PERCENT ] ] 
 --* | {column_name | expression [alias],…} 
--FROM tableName
--[WHERE conditional expressions]
--ORDER BY expression1 [ASC | DESC], expression2 [ASC | DESC] …
--SELECT: Phép chiếu để chọn ra các cột của bảng. Có thể kết hợp với Distinct để loại trừ trùng lặp. Top / 
--Percent để hiện thị n dòng / n% dòng đầu tiên của bảng.
--FROM: chọn bảng để thao tác
--WHERE: điều kiện áp dụng vào bảng
--ORDER có thể có hoặc không, hiển thị theo thứ tự sắp xếp được yêu cầu. Sắp xếp expression1 trước, 
--nếu bằng nhau thì sắp xếp theo expression 2.


--2. Đổi tên / Đặt tên: Sử dụng "as"
--Ví dụ: SELECT Product as Productname (Sẽ hiển thị cột Product nhưng tên cột sẽ thay bằng 
--Productname)
--Một ví dụ khác:
--(SELECT TOP 5 UnitPrice
--FROM Products
--ORDER BY UnitPrice desc) AS TOP 5


--3. s LIKE p
--Sử dụng để lọc ra các giá trị s giống p
--"%" đại diện cho 1 chuỗi kí tự, "_" đại diện cho 1 kí tự.
--VD: WHERE title LIKE 'man%' = title bắt đầu bằng 'man'
--'%man%' = title có chứa 'man'
--'-----' = title chỉ có 5 kí tự.
--'[S,Q]%' = bắt đầu với S hoặc Q (lệnh gộp)

--<, >, <=, >=, =, <>
--AND, OR
--SELECT *
--FROM STUDENT A, CLASS B
--WHERE A.class_id = B.class_id

--SELECT *
--FROM STUDENT A INNER JOIN CLASS B
--WHERE A.class_id = B.class_id

--INNER JOIN là A giao B
-- LEFT JOIN là lay het A
-- RIGHT JOIN là lấy hết B
-- FULL JOIN là lấy hết AB
--UNION loại bỏ trùng lặp, UNION ALL giữ trùng lặp4

-- EXISTS R : nếu có tồn tại R
--s IN R: nếu s có giá trị bằng 1 biến trong R
--s > ALL R: nếu s có giá trị lớn hơn mọi giá  trị R
--s> any R: nếu s lớn hơn ít nhất một biến trong E
-- AVG() trung bình
--COUNT() đếm 
--MAX() lớn nhất
--MIN() nhỏ nhất 
--SUM() Tổng

-- HAVING để đặt điều kiện cho group by
--SELECT bophan, SUM(sl) AS 'Tong so luong'
--FROM sanpham
--group by bophan
--Having SUm(sl)>100
--INSERT INTO Product(,)
--VALUES (,)
--    PersonID int FOREIGN KEY REFERENCES Persons(PersonID)
CREATE DATABASE NHANSU
-- TAO DATABASE

CREATE TABLE DEPARTMENTS (
DEPARTMENT_ID   VARCHAR(4)  PRIMARY KEY,
DEPARTMENT_NAME VARCHAR(20) NOT NULL,
MANAGER_ID      VARCHAR(6)  NULL,
LOCATION_ID     VARCHAR(6)  NULL
);
--TAO TABLE PHONGBAN

CREATE TABLE EMPLOYEES (
EMPLOYEE_ID    VARCHAR(12)  PRIMARY KEY,
FIRST_NAME     VARCHAR(20)  NOT NULL,
LAST_NAME      VARCHAR(25)  NOT NULL,
EMAIL          VARCHAR(25)  NOT NULL,
PHONE_NUMBER   VARCHAR(20)  NULL,
HIRE_DATE      DATE         NOT NULL,
JOB_ID         VARCHAR(10)  NOT NULL,
SALARY         DECIMAL(8,2) NOT NULL,
COMMISSION_PCT DECIMAL(2,2) NULL,
MANAGER_ID     VARCHAR(6)   NULL,
DEPARTMENT_ID  VARCHAR(4)   NOT NULL
);
--TAO TABLE NHANVIEN

ALTER TABLE EMPLOYEES 
ADD CONSTRAINT  AD001
    FOREIGN KEY (DEPARTMENT_ID)
	REFERENCES  DEPARTMENTS(DEPARTMENT_ID)
--TAO LIEN KET GIUA 2 BANG ( XAC DINH FIELD KHOA NGOAI CHO TABLE NHANVIEN)

CREATE TABLE INVOICE (
INVOICE_NUMBER     NUMERIC(7)   NOT NULL,
CUSTOMER_NUMBER    NUMERIC(5)   NOT NULL,
CUSTOMER_PO_NUMBER VARCHAR(10)  NULL,
SHIP_VIA           VARCHAR(30)  NULL,
ORDER_DATE         DATE         NOT NULL
);
--TAO TABLE HOA DON

ALTER TABLE INVOICE 
ADD CONSTRAINT HD1
PRIMARY KEY (INVOICE_NUMBER)
--ADD THUOC TINH KHOA CHINH --> ADD NHIEU FIELD LAM KHOA

INSERT INTO DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID)
VALUES ('IT01','QUAN LY DU AN CNTT',NULL,NULL)
INSERT INTO DEPARTMENTS
VALUES ('IT03','Quan tri nhan su',NULL,NULL)
--CHEN DU LIEU VAO TABLE PHONGBAN 
SELECT* FROM DEPARTMENTS
--KIEM TRA
CREATE DATABASE TRANDAIANHMINH

CREATE TABLE SV_SE162088(
MASV VARCHAR(8) PRIMARY KEY,
TENSV     VARCHAR(20)  NOT NULL,
)
CREATE DATABASE TRANDAIANHMINH

CREATE TABLE SV_SE162088(
MASV VARCHAR(8) PRIMARY KEY,
HOSV      VARCHAR(25)  NOT NULL,
TENSV     VARCHAR(20)  NOT NULL,
PHAI VARCHAR(3) NOT NULL,
NGAY SINH DATE NOT NULL,
NOI SINH VARCHAR(30)
)
CREATE TABLE KQ_SE162088(
MASV VARCHAR(8) PRIMARY KEY,
MAMH      VARCHAR(8)  PRIMARY KEY,
DIEM_Q    NUMERIC(2,1)  NOT NULL,
DIEM_L    NUMERIC(2,1)  NOT NULL,
DIEM_AS    NUMERIC(2,1)  NOT NULL,
)
CREATE TABLE MH_SE162088(
MAMH      VARCHAR(8)  PRIMARY KEY,
TENMH VARCHAR(20) NOT NULL,
SO TIET NUMERIC(2,0) NOT NULL)
ALTER TABLE KQ_SE162088
ADD CONSTRAINT  AA001
    FOREIGN KEY (MASV)
	REFERENCES  SV_SE162088(MASV)
ALTER TABLE KQ_SE162088
ADD CONSTRAINT  AA002
    FOREIGN KEY (MAMH)
	REFERENCES  SV_SE162088(MAMH)
CREATE DATABASE TRANDAIANHMINH

--1 Dung cau lenh create table tao 3 bang

CREATE TABLE SV_SE162088(
MASV VARCHAR(8) PRIMARY KEY,
HOSV      VARCHAR(25)  NOT NULL,
TENSV     VARCHAR(20)  NOT NULL,
PHAI VARCHAR(3) NOT NULL,
NGAYSINH DATE NOT NULL,
NOISINH VARCHAR(30)
)
CREATE TABLE KQ_SE162088(
MASV VARCHAR(8),
MAMH      VARCHAR(8),
DIEM_Q    NUMERIC(2,1)  NOT NULL,
DIEM_L    NUMERIC(2,1)  NOT NULL,
DIEM_AS    NUMERIC(2,1)  NOT NULL,
)
CREATE TABLE MH_SE162088(
MAMH      VARCHAR(8)  PRIMARY KEY,
TENMH VARCHAR(30) NOT NULL,
SOTIET NUMERIC(2,0) NOT NULL
)

--2 Dung cay lenh alter table de cai dat lien ket 1-N

ALTER TABLE KQ_SE162088
ADD CONSTRAINT  AA001
    FOREIGN KEY (MASV)
	REFERENCES  SV_SE162088(MASV)

ALTER TABLE KQ_SE162088
ADD CONSTRAINT  AA001
    FOREIGN KEY (MASV)
	REFERENCES  SV_SE162088(MASV)

--3 Thuc hien cau lenh insert de nhap du lieu vao ba bang 

INSERT INTO SV_SE162088
VALUES ('SE162088','Tran Dai Anh','Minh','Nam','2002-12-12','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162205','Nguyen Anh','Duy','Nam','2002-12-12','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162406','Nguyen Ngoc','Khuong','Nữ','2002-11-04','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162930','Hoang Tuan','Minh','Nam','2002-05-27','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162119','Le Quang','An','Nam','2002-08-17','TP HCM')
INSERT INTO SV_SE162088
VALUES ('SE162492','Pham Ngoc','Han','Nu','2002-04-19','TP HCM')

INSERT INTO MH_SE162088
VALUES ('TRS601','Database Systems',30)
INSERT INTO MH_SE162088
VALUES ('IOT102','Internet of Things',15)
INSERT INTO MH_SE162088
VALUES ('MAS291','Probability & statistics',30)
INSERT INTO MH_SE162088
VALUES ('JPD113','Japanese 1',30)
INSERT INTO MH_SE162088
VALUES ('MAE101','Mathematics for Engineering',30)
INSERT INTO MH_SE162088
VALUES ('VOV123','Vovinam 2',30)

INSERT INTO KQ_SE162088
VALUES ('SE162088','TRS601',7.5,8,7)
INSERT INTO KQ_SE162088
VALUES ('SE162205','IOT102',10,10,10)
INSERT INTO KQ_SE162088
VALUES ('SE162406','MAS291',8.5,9.6,9.1)
INSERT INTO KQ_SE162088
VALUES ('SE162205','IOT102',6.7,7.5,8.3)
INSERT INTO KQ_SE162088
VALUES ('SE162119','JPD113',8.5,9,10)
INSERT INTO KQ_SE162088
VALUES ('SE162492','VOV123',10,10,10)
USE NHANSU
GO

UPDATE EMPLOYEES
SET SALARY = [SALARY]*2
WHERE DEPARTMENT_ID = 'IT01'

INSERT INTO EMPLOYEES
VALUES('929', 'Werdna', 'leppo', 'leppo@whatever.com', null, GETDATE(), 'IT_PROG', 15000, 0.0, 103, 'IT01')

INSERT INTO DEPARTMENTS
VALUES('IT02', 'Quan ly nhan su', Null, Null)

SELECT *
FROM DEPARTMENTS

DELETE FROM DEPARTMENTS
WHERE DEPARTMENT_ID = 'IT01'

DECLARE @A int = 1, @B int = 3, @C NVARCHAR(20) =N'Hello FPT'
SELECT @A,@B,@C

DECLARE @A int = 1, @B int = 3, @C NVARCHAR(20) =N'Hello FPT'
SELECT @A AS A, @B AS B, @C AS C

DECLARE @VendorIDVar int,
@MaxInvoice money
--@MinInvoice money,
SET     @VendorIDVar = 35

SET     @MaxInvoice = (SELECT MAX(InvoiceTotal)
FROM INVOICE
WHERE VendorID = @VendorIDVar)
SELECT @MaxInvoice
PROHE02-2wed5azvq89vmx
PROHE02-0dbj5g0rx9plm1
USE AP

IF OBJECT_ID('spCopyInvoices') IS NOT NULL    
DROP PROC spCopyInvoices
GO
CREATE PROC spCopyInvoices
AS    
IF OBJECT_ID('InvoiceCopy') IS NOT NULL        
DROP TABLE InvoiceCopy            
SELECT *    
INTO InvoiceCopy    
FROM Invoices 
EXEC  spCopyInvoices

SELECT *
FROM InvoiceCopy

CREATE PROC splnvTotal3
@InvTotal money OUTPUT,
@DateVar smalldatetime,
@VendorVar varchar(40) = '%'
AS
IF @DateVar IS NULL
SELECT @DateVar = MIN(InvoiceDate) FROM Invoices

SELECT @InvTotal = SUM(InvoiceTotal)
FROM Invoices JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
WHERE (InvoiceDate>= @DateVar) AND (VendorName LIKE @VendorVar)

DECLARE @MyInvToltal money
EXEC splnvTotal3
     @InvTotal = @MyInvToltal OUTPUT,
     @DateVar = '2008-06-01',@VendorVar='P%'
SELECT @MyInvToltal

DECLARE @MyInvToltal1 money
EXEC splnvTotal3
     @MyInvToltal OUTPUT,
     '2008-06-01','P%'
SELECT @MyInvToltal1

