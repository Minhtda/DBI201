SELECT A.ProductID,A.Name,A.Color,A.Cost,A.Price,B.LocationID,C.Name AS 'LocationName',B.Bin,B.Shelf,B.Quantity
FROM Product A
LEFT JOIN ProductInventory B ON A.ProductID = B.ProductID
LEFT JOIN Location C ON B.LocationID = C.LocationID
WHERE (A.Color LIKE 'Yellow') and (A.Cost < 400 )