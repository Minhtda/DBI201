--1
CREATE TABLE Roles(
RoleID int PRIMARY KEY,
name nvarchar(100)
)
CREATE TABLE Users(
Username varchar(30) PRIMARY KEY,
Password nvarchar(20),
Email nvarchar(200),
RoleID int FOREIGN KEY REFERENCES Roles(RoleID)
)
CREATE TABLE Permissions(
permissionID int PRIMARY KEY,
name nvarchar(50)
)
CREATE TABLE hasPermission(
permissionID int FOREIGN KEY REFERENCES Permissions(permissionID),
RoleID int FOREIGN KEY REFERENCES Roles(RoleID)
)
--2
SELECT *
FROM Product
WHERE SellEndDate like '%2003%'
--3
SELECT p.ProductID, p.Name, p.Price
FROM Product p
lEFT JOIN ProductInventory i on p.ProductID=i.ProductID
LEFT JOIN Location l ON i.LocationID=l.LocationID
WHERE l.Name like 'Paint Shop'
--4
SELECT A.ProductID,A.Name,A.Color,A.Cost,A.Price,B.LocationID,C.Name AS 'LocationName',B.Bin,B.Shelf,B.Quantity
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
--6
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
--8
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
--9
DROP TRIGGER tr_insert_Product_Subcategory
CREATE TRIGGER tr_insert_Product_Subcategory
on Product instead of insert 
AS
BEGIN 
	SELECT A.ProductID,A.Name AS 'ProductName',A.SubcategoryID,B.Name AS'SubcategoryName',B.Category
FROM inserted A, ProductSubcategory B
	WHERE A.SubcategoryID = B.SubcategoryID
END
--10
DELETE FROM ProductInventory 
WHERE LocationID IN 
( SELECT A.LocationID
FROM Location A
WHERE A.Name = 'Tool Crib' )
SELECT *
FROM ProductInventory
WHERE LocationID IN 
( SELECT A.LocationID
FROM Location A
WHERE A.Name = 'Tool Crib' )
