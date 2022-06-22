-- Returns schema and object level permission grants and denies

SELECT dp.class_desc
    ,s.NAME AS 'Schema'
    ,o.NAME AS 'Object'
    ,dp.permission_name
    ,dp.state_desc
    ,prin.[name] AS 'User'
FROM sys.database_permissions dp
INNER JOIN sys.database_principals prin ON dp.grantee_principal_id = prin.principal_id
INNER JOIN sys.objects o ON dp.major_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE dp.class_desc = 'OBJECT_OR_COLUMN'

UNION ALL

SELECT dp.class_desc
    ,s.NAME AS 'Schema'
    ,'-----' AS 'Object'
    ,dp.permission_name
    ,dp.state_desc
    ,prin.[name] AS 'User'
FROM sys.database_permissions dp
INNER JOIN sys.database_principals prin ON dp.grantee_principal_id = prin.principal_id
INNER JOIN sys.schemas s ON dp.major_id = s.schema_id
WHERE dp.class_desc = 'SCHEMA'
ORDER BY 5,3;
