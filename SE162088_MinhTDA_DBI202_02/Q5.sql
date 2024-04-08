SELECT A.ModelID,A.Name AS 'ModelName',COUNT(B.ProductID) AS 'NumberOfProducts'
FROM ProductModel A
LEFT JOIN Product B ON A.ModelID = B.ModelID
GROUP BY A.ModelID,A.Name
HAVING (A.Name LIKE 'Mountain%') OR (A.Name LIKE 'ML Mountain%')
ORDER BY COUNT(B.ProductID) DESC, A.Name ASC