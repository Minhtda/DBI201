SELECT R.LocationID,R.LocationName,R.ProductID,R.ProductName,R.Quantity
FROM (
SELECT A.LocationID,C.Name AS 'LocationName', B.ProductID,B.Name AS 'ProductName',A.Quantity,
			RANK() OVER (PARTITION BY A.LocationID ORDER BY A.Quantity DESC) AS T 
FROM ProductInventory A 
LEFT JOIN Product B ON A.ProductID = B.ProductID
INNER JOIN Location C ON A.LocationID = C.LocationID) AS R
WHERE R.T = 1 
ORDER BY R.LocationName ASC,R.ProductName DESC