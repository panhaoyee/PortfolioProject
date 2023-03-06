SELECT Title, Production_companies, Release_date, Budget, Revenue, [Runtime (hour)]
FROM movies
WHERE Production_companies like '%Marvel Studio%' 
AND Release_date BETWEEN '2008' AND '2023'
AND [Runtime (hour)] > 1
AND Budget > '0'
AND Revenue > '0'
ORDER BY Release_date DESC
