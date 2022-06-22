-- Returns list of logical storage devices on server

SELECT DISTINCT 
   dovs.logical_volume_name AS LogicalName
  ,dovs.volume_mount_point AS Drive
  ,CONVERT(decimal(12,2), dovs.available_bytes / 1024.0 / 1024.0 / 1024.0) AS FreeSpaceInGB
  ,CONVERT(decimal(12,2), dovs.total_bytes / 1024.0 / 1024.0 / 1024.0) AS TotalSpaceInGb
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY Drive ASC
GO


