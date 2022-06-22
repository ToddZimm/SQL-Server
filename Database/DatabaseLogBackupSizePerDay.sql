-- Returns transaction log backup size per day

SELECT bs.database_name
  ,CAST(bs.backup_start_date AS DATE) [Date]
  ,(SUM(bs.backup_size) / 1024.0 / 1024.0 / 1024.0) SizeGB
  ,(SUM(bs.compressed_backup_size) / 1024.0 / 1024.0 / 1024.0) CompressedSizeGB
FROM msdb.dbo.backupmediafamily bmf
INNER JOIN msdb.dbo.backupmediaset bms ON bmf.media_set_id = bms.media_set_id
INNER JOIN msdb.dbo.backupset bs ON bms.media_set_id = bs.media_set_id
WHERE bs.[type] = 'L'
GROUP BY bs.database_name, CAST(bs.backup_start_date AS DATE)
ORDER BY database_name, Date DESC