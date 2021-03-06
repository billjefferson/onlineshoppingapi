
IF EXISTS(SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('[Customer].[sp_GetProducts]') AND TYPE = 'P')
DROP PROCEDURE [Customer].[sp_GetProducts]
GO
CREATE PROCEDURE [Customer].[sp_GetProducts]
	@Name NVARCHAR(100),
	@StartPage INT,
	@RowsPerPage INT
AS
BEGIN
	
	DECLARE @StartRow INT = ((@StartPage - 1) * @RowsPerPage) 
	--DECLARE @EndRow INT = (@StartRow + @RowsPerPage) - 1
	--SELECT [Name], [Description], Price FROM (
	--	SELECT ROW_NUMBER() OVER(ORDER BY Id) AS RN, * FROM Product.Details
	--	WHERE Name LIKE '%'+@Name+'%'
	--)T
	--WHERE RN >= @StartRow AND RN <= @EndRow
	
	--https://social.technet.microsoft.com/wiki/contents/articles/23811.paging-a-query-with-sql-server.aspx
	SELECT [Name], [Description], Price 
	FROM Product.Details
	ORDER BY Name
	OFFSET (@StartRow) ROWS
	FETCH NEXT @RowsPerPage ROWS ONLY

END
