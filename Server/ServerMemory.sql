-- Returns memory settings and current usage

SELECT 
  CAST((total_physical_memory_kb / 1024.0 / 1024.0) AS decimal(9,2)) TotalServerMemoryGb
  ,CAST((available_physical_memory_kb / 1024.0 / 1024.0) AS decimal(9,2)) AvailableServerMemoryGb
  ,CAST((total_page_file_kb / 1024.0 / 1024.0) AS decimal(9,2)) TotalPageFileGb
  ,CAST((available_page_file_kb / 1024.0 / 1024.0) AS decimal(9,2)) AvailablePageFileGb
  ,CAST((system_cache_kb / 1024.0 / 1024.0) AS decimal(9,2)) SystemCacheGb
  ,system_memory_state_desc SystemMemoryState
  ,(SELECT CAST((physical_memory_in_use_kb / 1024.0 / 1024.0) AS decimal(9,2)) FROM sys.dm_os_process_memory) AS SqlServerUsedMemoryGb
  ,(SELECT CAST(c.value_in_use AS decimal(9,2)) / 1024 FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)') MaxServerMemorySettingGb
FROM sys.dm_os_sys_memory
