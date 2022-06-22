-- Return list of stored procedures and when last executed since last server reboot.

SELECT 
   s.name SchemaName
  ,o.NAME ProcedureName
  ,ps.last_execution_time LastExecutedTime
FROM sys.objects o
LEFT JOIN sys.schemas s ON o.schema_id = s.schema_id
LEFT JOIN sys.dm_exec_procedure_stats ps ON ps.object_id = o.object_id
WHERE o.type IN ('P', 'PC')
ORDER BY o.name