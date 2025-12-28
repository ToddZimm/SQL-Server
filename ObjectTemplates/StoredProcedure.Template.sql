/******************************************************************************
 Author:      <Author Name>
 Create date: <Create Date>
 Description: <Description>
******************************************************************************/
CREATE OR ALTER PROCEDURE dbo.ProcName
  @Param1 nvarchar(200),
  @Param2 int = 0
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    -- Insert statements for procedure here

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
  END CATCH

  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

END
GO
