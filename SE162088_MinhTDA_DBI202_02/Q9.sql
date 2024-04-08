CREATE TRIGGER tr_insert_Product_Subcategory
on Product instead of insert 
AS
BEGIN 
	SELECT A.ProductID,A.Name AS 'ProductName',A.SubcategoryID,B.Name AS'SubcategoryName',B.Category
FROM inserted A, ProductSubcategory B
	WHERE A.SubcategoryID = B.SubcategoryID
END