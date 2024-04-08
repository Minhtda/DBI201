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