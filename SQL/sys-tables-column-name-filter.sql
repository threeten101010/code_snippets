SELECT *
FROM (
	SELECT *
	FROM sys.tables
	) T1
INNER JOIN (
	SELECT *
	FROM sys.columns
	where [name] LIKE '%xml%'
	) T2
ON T1.object_id = T2.object_id
ORDER BY 1
