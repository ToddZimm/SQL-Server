-- Returns partitioned table statistics

SELECT PartitionScheme AS [Partition Scheme Name],
       PartitionFunction AS [Partition Function Name],
          FileGroupName AS [File Group Name],
          rows AS [Record Count],
          CAST(SUM(CAST(sf.size AS BIGINT))/131072.0 AS DECIMAL(19,2)) AS [Size GB],
          PartitionFunctionValue AS [Partition Function Value]
FROM
(select distinct ps.Name AS PartitionScheme, pf.name AS PartitionFunction,fg.name AS FileGroupName,
 p.rows, prv.value AS PartitionFunctionValue,fg.data_space_id
    from sys.indexes i 
    join sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id 
    join sys.partition_schemes ps on ps.data_space_id = i.data_space_id 
    join sys.partition_functions pf on pf.function_id = ps.function_id 
    left join sys.partition_range_values prv on prv.function_id = pf.function_id AND prv.boundary_id = p.partition_number
    join sys.allocation_units au  ON au.container_id = p.hobt_id  
    join sys.filegroups fg  ON fg.data_space_id = au.data_space_id 
    where i.object_id = object_id('dbo.EncounterFact')) a
join sys.sysfiles sf ON a.data_space_id=sf.groupid
GROUP BY PartitionScheme,PartitionFunction,FileGroupName,rows,PartitionFunctionValue
ORDER BY PartitionFunctionValue