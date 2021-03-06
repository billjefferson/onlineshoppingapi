USE [master]
GO
/****** Object:  Database [OnlineShopping]    Script Date: 29/11/2019 3:56:03 PM ******/
CREATE DATABASE [OnlineShopping]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'pos', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER2017\MSSQL\DATA\pos.mdf' , SIZE = 335872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'pos_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER2017\MSSQL\DATA\pos_log.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [OnlineShopping] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OnlineShopping].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OnlineShopping] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnlineShopping] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnlineShopping] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnlineShopping] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnlineShopping] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnlineShopping] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OnlineShopping] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnlineShopping] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnlineShopping] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnlineShopping] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnlineShopping] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnlineShopping] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnlineShopping] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnlineShopping] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnlineShopping] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OnlineShopping] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnlineShopping] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnlineShopping] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OnlineShopping] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OnlineShopping] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnlineShopping] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OnlineShopping] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OnlineShopping] SET RECOVERY FULL 
GO
ALTER DATABASE [OnlineShopping] SET  MULTI_USER 
GO
ALTER DATABASE [OnlineShopping] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OnlineShopping] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OnlineShopping] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OnlineShopping] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [OnlineShopping] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'OnlineShopping', N'ON'
GO
ALTER DATABASE [OnlineShopping] SET QUERY_STORE = OFF
GO
USE [OnlineShopping]
GO
/****** Object:  Schema [Customer]    Script Date: 29/11/2019 3:56:04 PM ******/
CREATE SCHEMA [Customer]
GO
/****** Object:  Schema [Error]    Script Date: 29/11/2019 3:56:04 PM ******/
CREATE SCHEMA [Error]
GO
/****** Object:  Schema [Product]    Script Date: 29/11/2019 3:56:04 PM ******/
CREATE SCHEMA [Product]
GO
/****** Object:  Table [Customer].[Account]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NULL,
	[Password] [nvarchar](250) NULL,
 CONSTRAINT [PK_Customer_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Error].[Logs]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Error].[Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NULL,
	[ErrorMsg] [nvarchar](max) NULL,
 CONSTRAINT [PK_ErrorLogs_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Product].[Details]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[Details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[Price] [money] NULL,
 CONSTRAINT [PK_Products_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Product_Details_Name]    Script Date: 29/11/2019 3:56:05 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Details_Name] ON [Product].[Details]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [Customer].[sp_GetProducts]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
GO
/****** Object:  StoredProcedure [Customer].[sp_LogIn]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
GO
/****** Object:  StoredProcedure [Error].[sp_AddLogs]    Script Date: 29/11/2019 3:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Error].[sp_AddLogs]
@LogDate datetime,
@ErrorMsg nvarchar(max)
AS
BEGIN
	INSERT INTO Error.Logs(LogDate, ErrorMsg) VALUES(@LogDate, @ErrorMsg)
END
GO
USE [master]
GO
ALTER DATABASE [OnlineShopping] SET  READ_WRITE 
GO
