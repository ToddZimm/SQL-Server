-- Returns list of database files for the current database

SELECT 
   DB_NAME() AS DatabaseName
  ,NAME AS FileName
  ,type_desc AS FilyType
  ,LEFT(physical_name, 2) AS Drive
  ,physical_name AS PhysicalLocation
  ,CAST(((cast(size AS DECIMAL) * 8.0) / 1024.0) / 1024.0 AS DECIMAL(18, 2)) AS FileSizeGb
  ,Cast((FILEPROPERTY(NAME, 'SpaceUsed') * 8.0) / 1024.0 / 1024.0 AS DECIMAL(18, 2)) SpaceUsedGb
  ,Cast(cast((size - FILEPROPERTY(NAME, 'SpaceUsed')) AS DECIMAL) * 8.0 / 1024.0 / 1024.0 AS DECIMAL(18, 2)) AS FreeSpaceGb
  ,GetDate() AS ScanTime
FROM sys.database_files
ORDER BY 3, 2, 4
