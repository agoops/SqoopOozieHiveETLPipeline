$subscriptionName = "Telesales Reporting - Dev"
$clusterName = "crmhivecluster"

$sqlDatabaseServerName = "mpe7cbgx19"
$sqlDatabaseUserName = "t-ankigu"
$sqlDatabasePassword = "turtledive11)"
$sqlDatabaseDatabaseName = "NGTReportingStage"



Write-Host "Starting upload" -BackgroundColor Green


$tableName = "ActivityPointerBase"
$hdfsOutputDir = "/$tableName" + "Data" 

$sqoopDef = New-AzureHDInsightSqoopJobDefinition -Command "import --connect jdbc:sqlserver://$sqlDatabaseServerName.database.windows.net:1433;user=$sqlDatabaseUserName@$sqlDatabaseServerName;password=$sqlDatabasePassword;database=$sqlDatabaseDatabaseName --table $tableName --hive-delims-replacement \t --fields-terminated-by \001 --target-dir $hdfsOutputDir -m 1" 

#flags to use... 

$sqoopJob = Start-AzureHDInsightJob -Cluster $clusterName -JobDefinition $sqoopDef #-Debug
Wait-AzureHDInsightJob -WaitTimeoutInSeconds 3600 -Job $sqoopJob

Write-Host "Standard Error" -BackgroundColor Green
Get-AzureHDInsightJobOutput -Cluster $clusterName -JobId $sqoopJob.JobId -StandardError
Write-Host "Standard Output" -BackgroundColor Green
Get-AzureHDInsightJobOutput -Cluster $clusterName -JobId $sqoopJob.JobId -StandardOutput

Write-Host "Finished $tableName" -BackgroundColor Red


