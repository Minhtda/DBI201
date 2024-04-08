DELETE FROM ProductInventory 
WHERE LocationID IN 
( SELECT A.LocationID
FROM Location A
WHERE A.Name = 'Tool Crib' )