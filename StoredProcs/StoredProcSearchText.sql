-- Searches store procedure text for a string

DECLARE @SearchTerm nvarchar(500) = 'test'

SELECT
   OBJECT_SCHEMA_NAME(mods.object_id) AS 'Schema'
  ,o.NAME AS 'ObjectName'
  ,o.type_desc AS 'ObjectType'
  ,ps.last_execution_time AS 'LastExecutedTime'
FROM sys.sql_modules mods
  LEFT JOIN sys.objects o ON mods.object_id = o.object_id
  LEFT JOIN sys.dm_exec_procedure_stats ps ON ps.object_id = o.object_id
WHERE mods.[definition] LIKE '%' + @SearchTerm + '%'
ORDER BY o.name