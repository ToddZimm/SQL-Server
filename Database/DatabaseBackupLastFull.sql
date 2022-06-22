-- Returns list of last full backup for each database

WITH LastBackUp AS
(
SELECT  bs.database_name,
        bs.backup_size,
        bs.backup_start_date,
        bmf.physical_device_name,
        Position = ROW_NUMBER() OVER( PARTITION BY bs.database_name ORDER BY bs.backup_start_date DESC )
FROM  msdb.dbo.backupmediafamily bmf
JOIN msdb.dbo.backupmediaset bms ON bmf.media_set_id = bms.media_set_id
JOIN msdb.dbo.backupset bs ON bms.media_set_id = bs.media_set_id
WHERE   bs.[type] = 'D'
AND bs.is_copy_only = 0
)
SELECT 
  sd.name AS [Database],
  CAST(backup_size / 1048576 AS DECIMAL(10, 2) ) AS [BackupSizeMB],
  backup_start_date AS [Last Full DB Backup Date],
  physical_device_name AS [Backup File Location]
FROM sys.databases AS sd
LEFT JOIN LastBackUp AS lb
  ON sd.name = lb.database_name
  AND Position = 1
ORDER BY [Database];