IF OBJECT_ID ('dbo.SplitString') IS NOT NULL 
    DROP FUNCTION dbo.SplitString 
GO 
 
SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
 
-- ========================================================= 
-- Author:      Todd Zimmerman 
-- Create date: 2015-04-28 
-- Description: Splits a string into rows based on separator 
-- ========================================================= 
CREATE FUNCTION [dbo].[SplitString]   
(   
 @String NVARCHAR(MAX),    
 @Separator NVARCHAR(200)   
)   
RETURNS @value TABLE (Value NVARCHAR(2000))   
AS   
BEGIN   
  
 DECLARE @xml XML = (SELECT CONVERT(XML,'<r>' + REPLACE(@String,@Separator,'</r><r>') + '</r>')) 
  
 INSERT INTO @value(Value) 
 SELECT t.value('.','NVARCHAR(2000)') 
 FROM @xml.nodes('/r') AS x(t) 
    
 RETURN;   
END 