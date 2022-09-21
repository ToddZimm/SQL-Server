-- Pivot an entity-attribute-value style table using GROUP BY and CASE

-- Sample data
CREATE TABLE #eav (entity int, attribute nvarchar(50), attrib_value nvarchar(500));
INSERT INTO #eav (entity, attribute, attrib_value)
VALUES
(1, 'name', 'George'),
(1, 'birthday', '1984-01-23'),
(1, 'hourly-rate', '15.32'),
(2, 'name', 'Michael'),
(2, 'birthday', '1980-11-14'),
(2, 'hourly-rate', '20.50');

SELECT * FROM #eav;

SELECT entity
  ,MAX(CASE WHEN attribute = 'name' THEN CAST(attrib_value AS nvarchar(200)) END) AS name
  ,MAX(CASE WHEN attribute = 'birthday' THEN CAST(attrib_value AS date) END) AS birthday
  ,MAX(CASE WHEN attribute = 'hourly-rate' THEN CAST(attrib_value AS decimal(8,2)) END) AS hourly_rate
FROM #eav
GROUP BY entity;

DROP TABLE #eav;