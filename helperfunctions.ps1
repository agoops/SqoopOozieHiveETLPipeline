#HDInsight cluster variables
$clusterName = "crmhivecluster"
$clusterUsername = "admin"
$clusterPassword = "Turtledive11)"


$passwd = ConvertTo-SecureString $clusterPassword -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($clusterUsername, $passwd)


function listOozieJobs()
{
    Write-Host "Listing Oozie jobs..." -ForegroundColor Green
    $clusterUriStatus = "https://$clusterName.azurehdinsight.net:443/oozie/v2/jobs"
    $response = Invoke-RestMethod -Method Get -Uri $clusterUriStatus -Credential $creds 

    Write-host "Job ID                                   App Name        Status      Started                         Ended"
    Write-host "----------------------------------------------------------------------------------------------------------------------------------"
    foreach($job in $response.workflows)
    {
        Write-Host $job.id "`t" $job.appName "`t" $job.status "`t" $job.startTime "`t" $job.endTime
    }
}

function ShowOozieJobLog($oozieJobId)
{
    Write-Host "Showing Oozie job info..." -ForegroundColor Green
    $clusterUriStatus = "https://$clusterName.azurehdinsight.net:443/oozie/v2/job/$oozieJobId" + "?show=log"
    $response = Invoke-RestMethod -Method Get -Uri $clusterUriStatus -Credential $creds 
    Write-host $response
}

function killOozieJob($oozieJobId)
{
    Write-Host "Killing the Oozie job $oozieJobId..." -ForegroundColor Green
    $clusterUriStartJob = "https://$clusterName.azurehdinsight.net:443/oozie/v2/job/" + $oozieJobId + "?action=kill" #Valid values for the 'action' parameter are 'start', 'suspend', 'resume', 'kill', 'dryrun', 'rerun', and 'change'.
    $response = Invoke-RestMethod -Method Put -Uri $clusterUriStartJob -Credential $creds | Format-Table -HideTableHeaders -debug
}



