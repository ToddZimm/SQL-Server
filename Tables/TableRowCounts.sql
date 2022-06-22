-- Returns list of user tables and row count

SELECT
   SCHEMA_NAME(o.schema_id) AS SchemaName
  ,o.name AS TableName
  ,ddps.row_count AS Rows
FROM sys.indexes AS i
INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
    AND i.index_id = ddps.index_id
WHERE i.index_id < 2
    AND o.is_ms_shipped = 0
ORDER BY SchemaName, TableName
