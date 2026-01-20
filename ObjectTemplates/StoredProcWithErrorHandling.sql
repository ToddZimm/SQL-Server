
-- ===============================================================================
-- Author:		<< Author >>
-- Create date: << Date >>
-- Description:	<< Description >>
-- ================================================================================

CREATE OR ALTER PROCEDURE <<SchemaName>>.<<ProcName>>
  @Param1 bit = 0
AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;  -- roll back everything on unexpected error.

  BEGIN TRY
    BEGIN TRANSACTION;

    -- Do data manipulation here

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@trancount > 0 ROLLBACK TRANSACTION;
    DECLARE @msg50000 nvarchar(2048) = '<< Custom error message here >>: ' + error_message();
    THROW 50000, @msg50000, 1;
    RETURN 50000;
  END CATCH

  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

END;
GO

