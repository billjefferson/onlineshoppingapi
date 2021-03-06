IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID('[Customer].[sp_LogIn]') AND TYPE = 'P')
DROP PROCEDURE [Customer].[sp_LogIn]
GO
CREATE PROCEDURE [Customer].[sp_LogIn]
	@UserName nvarchar(100),
	@Password nvarchar(250)

AS
BEGIN
	IF EXISTS(SELECT 1 FROM Customer.Account WHERE Username = @Username AND "Password" = @Password)
		SELECT 1 AS Result
	ELSE IF EXISTS(SELECT 1 FROM Customer.Account WHERE Username = @Username AND "Password" = @Password)
		SELECT 2 AS Result
END
