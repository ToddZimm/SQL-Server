-- Return information on the columns in a table

SELECT NAME 'ColumnName'
  ,TYPE_NAME(user_type_id) 'DataType'
  ,CASE 
    WHEN TYPE_NAME(user_type_id) LIKE 'date%' THEN ''
    ELSE CAST(max_length AS NVARCHAR(10)) + CASE scale
        WHEN 0 THEN ''
        ELSE ',' + CAST(scale AS NVARCHAR(10))
        END
    END 'Length'
  ,CASE is_nullable
    WHEN 0
      THEN 'No'
    ELSE 'Yes'
    END Nullable
FROM sys.all_columns
WHERE object_id = OBJECT_ID('dbo.MyTable')
ORDER BY column_id
