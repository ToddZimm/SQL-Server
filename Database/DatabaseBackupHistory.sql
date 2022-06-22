-- Returns list of transaction log backups
SELECT bs.database_name AS DatabaseName
	,CASE bs.type
	  WHEN 'D' THEN 'Full Database'
	  WHEN 'I' THEN 'Differential database'
	  WHEN 'L' THEN 'Log'
	  WHEN 'F' THEN 'File or filegroup'
	  WHEN 'G' THEN 'Differential file'
	  WHEN 'P' THEN 'Partial'
	  WHEN 'Q' THEN 'Differential partial'
	END BackupType
  ,bs.is_copy_only CopyOnly
  ,bs.backup_start_date BackupStartTime
  ,((bs.backup_size) / 1024.0 / 1024.0 / 1024.0) BackupSizeGB
  ,((bs.compressed_backup_size) / 1024.0 / 1024.0 / 1024.0) CompressedSizeGB
  ,bmf.physical_device_name As BackupLocation
FROM msdb.dbo.backupmediafamily bmf
INNER JOIN msdb.dbo.backupmediaset bms ON bmf.media_set_id = bms.media_set_id
INNER JOIN msdb.dbo.backupset bs ON bms.media_set_id = bs.media_set_id
WHERE bs.database_name = DB_NAME()
ORDER BY backup_start_date DESC