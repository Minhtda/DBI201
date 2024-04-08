SELECT I.ProductID, P.Name, SUM(I.Quantity) AS TotalQuantity
FROM Product P, ProductInventory I
WHERE P.ProductID = I.ProductID 
GROUP BY I.ProductID, P.Name
HAVING SUM(I.Quantity) = (SELECT TOP 1 SUM(I.Quantity) AS TotalQuantity
FROM Product P, ProductInventory I
WHERE P.ProductID = I.ProductID 
GROUP BY I.ProductID, P.Name
ORDER BY TotalQuantity DESC)