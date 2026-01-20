-- Script to check database synonyms
-- Set the name of the database the synonyms should be referencing in @TargetDb variable.
-- Use the statements in the DROP column to drop the bad synonyms
-- Recreate the synonyms with the proper references with the statements in the CREATE column.

DECLARE @TargetDb nvarchar(100) = 'TargetDatabaseName'

SELECT name, base_object_name,
'DROP SYNONYM ' + SCHEMA_NAME(schema_id) + '.' + name AS DROP_Statement,
'CREATE SYNONYM ' + SCHEMA_NAME(schema_id) + '.' + name + ' FOR ' + @TargetDb + '.' + PARSENAME(base_object_name, 2) + '.' + PARSENAME(base_object_name, 1) AS CREATE_Statement
FROM sys.synonyms
WHERE base_object_name NOT LIKE '[[]' + @TargetDb + '%'
