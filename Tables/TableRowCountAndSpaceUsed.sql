-- Returns list of user tables, row count and space used

SELECT s.Name AS SchemaName,
  t.Name AS TableName, 
  FORMAT(SUM(p.rows), 'n0') AS RowCounts,
  FORMAT(CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)), 'n2') AS Used_MB,
  FORMAT((CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) / 1024.00), 'n2') AS Used_GB,
  FORMAT(CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)), 'n2') AS Unused_MB,
  FORMAT(CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)), 'n2') AS Total_MB
FROM sys.tables t
INNER JOIN sys.partitions p ON t.[object_id] = p.[object_id]
  AND p.index_id IN (0, 1)
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY s.Name, t.Name
ORDER BY s.Name, t.Name
