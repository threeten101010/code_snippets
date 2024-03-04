CREATE PROCEDURE [dbo].[importXML]
(
  @toolName nvarchar(50),
  @filepath nvarchar(100)
)
AS
BEGIN
  DECLARE @pointer int = 0;
  DECLARE @sql nvarchar(max);
  DECLARE @filename nvarchar(100);
  DECLARE @applicationName nvarchar(50);

  WHILE @pointer < 2
  BEGIN
	  SET @applicationName = CASE WHEN @pointer = 0 THEN 'QA' ELSE 'Rehersal' END;
	  SET @filename = CONCAT(@filepath, @applicationName, '\', @toolName, '.xml');

	  SET @sql = N'INSERT INTO os.xmlFile
					SELECT
						  OSApplication = @applicationName,
						  OSTool = @toolName,
						  OSxml = CAST(MY_XML AS xml)
					FROM OPENROWSET(BULK ''' + @fileName + ''', SINGLE_BLOB) AS T(MY_XML)';

	  EXEC sp_executesql @sql, N'@applicationName nvarchar(50), @toolName nvarchar(50)',
						   @applicationName, @toolName;
	
	SET @pointer += 1
	END;

END;
