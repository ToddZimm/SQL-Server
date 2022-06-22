-- Returns all temp tables currently in use
USE tempdb

SELECT tb.name AS [TemporaryTableName]
  ,stt.row_count AS [RowCount]
  ,stt.used_page_count * 8 AS [UseSpaceKB]
  ,stt.reserved_page_count * 8 AS [ReservedSpaceKB]
  ,tb.create_date AS [CreateDate]
FROM tempdb.sys.partitions AS prt
INNER JOIN tempdb.sys.dm_db_partition_stats AS stt ON prt.partition_id = stt.partition_id
  AND prt.partition_number = stt.partition_number
INNER JOIN tempdb.sys.tables AS tb ON stt.object_id = tb.object_id
ORDER BY tb.name
