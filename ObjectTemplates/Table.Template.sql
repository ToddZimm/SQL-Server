CREATE TABLE dbo.YourTable(
  YourTableId bigint IDENTITY(1,1) NOT NULL,
  YourOtherColumns nvarchar(50) NULL
  CONSTRAINT pkYourTable PRIMARY KEY CLUSTERED (YourTableId)
) WITH(DATA_COMPRESSION = PAGE)
GO


