
/* Generic xmlfile query */
SELECT CAST(MY_XML AS xml)
  FROM OPENROWSET(BULK 'C:\filename.xml', SINGLE_BLOB) as T(MY_XML)


/* procedure to import xml file */
CREATE PROCEDURE [dbo].[importXML]
(
  @applicationName nvarchar(50),
  @toolName nvarchar(50),
  @fileName nvarchar(max)
)
AS
BEGIN
  DECLARE @sql nvarchar(max);

  SET @sql = N'INSERT INTO os.xmlFile
                SELECT
                      OSApplication = @applicationName,
                      OSTool = @toolName,
                      OSxml = CAST(MY_XML AS xml)
                FROM OPENROWSET(BULK ''' + @fileName + ''', SINGLE_BLOB) AS T(MY_XML)';

  EXEC sp_executesql @sql, N'@applicationName nvarchar(50), @toolName nvarchar(50)',
                       @applicationName, @toolName;
END;

GO
