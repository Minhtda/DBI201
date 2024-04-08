SELECT p.ProductID, p.Name, p.Price
FROM Product p
lEFT JOIN ProductInventory i on p.ProductID=i.ProductID
LEFT JOIN Location l ON i.LocationID=l.LocationID
WHERE l.Name like 'Paint Shop'