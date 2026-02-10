-- Returns index fragmentation order by importance with rebuild or reorg command.
SELECT
	dbschemas.[name] AS 'Schema',
	dbtables.[name] AS 'Table',
	dbindexes.[name] AS 'Index',
	indexstats.avg_fragmentation_in_percent,
	indexstats.page_count,
	cast(indexstats.avg_fragmentation_in_percent as bigint) * indexstats.page_count AS 'pain_score',
	CASE 
		WHEN indexstats.avg_fragmentation_in_percent BETWEEN 10 AND 30
		  THEN CONCAT('ALTER INDEX ', dbindexes.[name], ' ON ', dbtables.[name], ' REORGANIZE;')
		WHEN indexstats.avg_fragmentation_in_percent > 30
		  THEN CONCAT('ALTER INDEX ', dbindexes.[name], ' ON ', dbtables.[name], ' REBUILD WITH(ONLINE=ON);')
	END AS 'MaintenanceCommand'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.objects AS dbtables ON indexstats.object_id = dbtables.object_id
INNER JOIN sys.schemas AS dbschemas ON dbtables.schema_id = dbschemas.schema_id
INNER JOIN sys.indexes AS dbindexes ON indexstats.object_id = dbindexes.object_id
                                   AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.avg_fragmentation_in_percent > 10
  AND dbtables.type = 'U' -- Filter for user tables
ORDER BY pain_score DESC;
