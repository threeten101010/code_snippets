/****** Object:  StoredProcedure [dw].[ImportHistory]    Script Date: 5/23/2023 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      CGI Consulting - Aaron Berman
-- Description: Procedure allows loading of any CSV file in ANSI format using a format file
-- =============================================

CREATE PROCEDURE [dw].[ImportHistory]
    @filepath varchar(500), --'F:\DWimport\'
    @filename varchar(100), --'CSVTEST.csv'
    @formatFile varchar(100), --'FormatFile.fmt'
	@databasename varchar(100), --'IMPORT'
	@schemaname varchar(100), --'dbo'
    @tablename varchar(100) --'dbo.testTable'

	/*
	1) CREATE A FORMAT FILE (NAME.FMT) IN THE SAME DIRECTORY FOR MAPPING OF THE CSV FILE FOR BULK LOADING

		<?xml version="1.0"?>
		<BCPFORMAT xmlns="http://schemas.microsoft.com/sqlserver/2004/bulkload/format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<RECORD>
			<FIELD ID="1" xsi:type="CharTerm" TERMINATOR=',' MAX_LENGTH="255"/>
			<FIELD ID="2" xsi:type="CharTerm" TERMINATOR=',' MAX_LENGTH="255"/>
			<FIELD ID="3" xsi:type="CharTerm" TERMINATOR='\r\n' MAX_LENGTH="255"/>
			</RECORD>
			<ROW>
			<COLUMN SOURCE="1" NAME="TEST1" xsi:type="SQLVARYCHAR"/>
			<COLUMN SOURCE="2" NAME="TEST2" xsi:type="SQLVARYCHAR"/>
			<COLUMN SOURCE="3" NAME="TEST3" xsi:type="SQLVARYCHAR"/>
			</ROW>
		</BCPFORMAT>

	2) MAKE SURE THE CSV ENCODING IS IN ANSI. USE NOTEPAD++ ENCODING TAB AND PRESS "CONVERT TO ANSI" TO ENSURE THE FILE IS CORRECTLY ENCODED.

	3) PARAMETERS FOR HISTORY FILES:
	   exampleTable: 'C:\address\', 'exampleTable.csv', 'exampleTable_FormatFile.fmt', 'DBname', 'schema', 'exampleTable'
	
	*/

AS
BEGIN
    DECLARE @sqlCommand nvarchar(max)

	--Truncate the STAGE table to ensure loading is performed one time
	SET @sqlCommand = '
        TRUNCATE TABLE ' + QUOTENAME(@databasename) +'.'+ QUOTENAME(@schemaname) +'.'+ QUOTENAME(@tablename)
	EXEC (@sqlCommand)

	--Execute INSERT query from BULK CSV
    SET @sqlCommand = '
        INSERT INTO ' + QUOTENAME(@databasename) +'.'+ QUOTENAME(@schemaname) +'.'+ QUOTENAME(@tablename) + '
        SELECT *
        FROM OPENROWSET(
            BULK ' + QUOTENAME(@filepath + @filename, '''') + ',
            FORMATFILE = ' + QUOTENAME(@filepath + @formatFile, '''') + ',
			CODEPAGE = ''ACP'',
            FIRSTROW = 2
        ) AS Data
        '
    --PRINT @sqlCommand
    EXEC (@sqlCommand)

END
GO
