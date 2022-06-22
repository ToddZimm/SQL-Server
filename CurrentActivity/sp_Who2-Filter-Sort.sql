-- Returns results of sp_who2 into a temp table to filter and sort the output
CREATE TABLE #sp_who2 (
    SPID INT
    ,STATUS VARCHAR(255)
    ,LOGIN VARCHAR(255)
    ,HostName VARCHAR(255)
    ,BlkBy VARCHAR(255)
    ,DBName VARCHAR(255)
    ,Command VARCHAR(255)
    ,CPUTime INT
    ,DiskIO INT
    ,LastBatch VARCHAR(255)
    ,ProgramName VARCHAR(255)
    ,SPID2 INT
    ,REQUESTID INT
    )

INSERT INTO #sp_who2
EXEC sp_who2

SELECT *
FROM #sp_who2
WHERE DBName <> 'master'
ORDER BY LastBatch desc

DROP TABLE #sp_who2
