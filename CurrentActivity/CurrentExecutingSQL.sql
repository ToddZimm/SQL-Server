-- Returns list of currently executing SQL statements and execution plans for the server

SELECT der.session_id
  ,der.blocking_session_id
  ,des.host_name
  ,des.login_name UserName
  ,DB_NAME(der.database_id) AS DBName
  ,DATEDIFF(second, der.start_time, getdate()) / 60.0 AS 'DurationMinutes'
  ,SUBSTRING(dest.TEXT, (der.statement_start_offset / 2) + 1, (
      CASE der.statement_end_offset
        WHEN - 1 THEN DATALENGTH(dest.TEXT)
        ELSE der.statement_end_offset - der.statement_start_offset
      END
   ) / 2 + 1) AS QueryStatement
  ,der.status AS Status
  ,des.program_name AS AppName
  ,der.start_time
  ,deqp.query_plan
  ,der.wait_type
  ,der.wait_time
  ,der.wait_resource
  ,der.last_wait_type
  ,der.cpu_time
  ,der.total_elapsed_time
  ,der.reads
  ,der.writes
FROM sys.dm_exec_requests AS der
LEFT JOIN sys.dm_exec_sessions AS des ON der.session_id = des.session_id
CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
OUTER APPLY sys.dm_exec_query_plan(der.plan_handle) AS deqp
ORDER BY blocking_session_id desc, [host_name], [UserName]
GO
