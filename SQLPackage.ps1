# Reference: https://azureops.org/articles/bacpac-large-sql-server-database/
# Reference: https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage?view=sql-server-ver16
# Reference: https://github.com/MicrosoftDocs/sql-docs/blob/live/docs/tools/sqlpackage/sqlpackage-script.md
# Reference: https://github.com/MicrosoftDocs/sql-docs/blob/live/docs/tools/sqlpackage/sqlpackage.md
# Reference: https://www.sqlsmarts.com/azure-devops-sqlpackage-deployment-timeouts/

$PathVariables=$env:Path
$OldTemp = $env:TMP
$env:TMP = "C:\temp\SqlPackageTemp" #Set temporary location of temp folder.
$SourceServerName = "."
$SourceDatabaseName = "Database"
$BacpacPath = "C:\temp\"
$SourceTimeOut = 0   # Int Seconds
 
SqlPackage.exe /a:Export /ssn:$SourceServerName /sdn:$SourceDatabaseName /stsc:True /st:$SourceTimeOut /p:CommandTimeout=0 /p:LongRunningCommandTimeout=0 /tf:$BacpacPath$SourceDatabaseName".bacpac" /df:$BacpacPath$SourceDatabaseName".log"
 
$env:TMP = $OldTemp
