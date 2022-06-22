-- Calculates recommended starting Max DOP setting

DECLARE 
   @NumaNodes INT
  ,@NumCPUs INT
  ,@MaxDop SQL_VARIANT
  ,@EpicMaxDop INT
  ,@CPUPerNode INT

-- Getting number of NUMA nodes
SELECT @NumaNodes = COUNT(DISTINCT memory_node_id)
FROM sys.dm_os_memory_clerks
WHERE memory_node_id != 64

-- Getting number of CPUs (cores)
SELECT @NumCPUs = COUNT(scheduler_id)
FROM sys.dm_os_schedulers
WHERE STATUS = 'VISIBLE ONLINE'

-- Getting current MAXDOP at instance level
SELECT @MaxDop = value_in_use
FROM sys.configurations
WHERE name = 'max degree of parallelism'

-- CPUs Per Node
SELECT @CPUPerNode = @NumCPUs / @NumaNodes

-- Results
SELECT @NumaNodes NumaNodes
  ,@NumCPUs NumCPUs
  ,@CPUPerNode  CPUsPerNode
  ,@MaxDop CurrentMaxDOP
  ,CASE WHEN @CPUPerNode < 8 THEN @CPUPerNode ELSE 8 END AS RecommendedMaxDOP
