IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID('[Error].[sp_AddLogs]') AND TYPE = 'P')
DROP PROCEDURE [Error].[sp_AddLogs]
GO
CREATE PROCEDURE [Error].[sp_AddLogs]
@LogDate datetime,
@ErrorMsg nvarchar(max)
AS
BEGIN
	INSERT INTO Error.Logs(LogDate, ErrorMsg) VALUES(@LogDate, @ErrorMsg)
END
