#

#HDInsight cluster variables
$clusterName = "crmhivecluster"
$clusterUsername = "admin"
$clusterPassword = "Turtledive11)"

#Azure Blob storage (WASB) variables
$storageAccountName = "crmhivestorage"
$storageContainerName = "crmhivecluster"
$storageUri="wasb://$storageContainerName@$storageAccountName.blob.core.windows.net"

#Oozie WF/coordinator variables
$coordStart = "2014-06-27T9:50Z"
$coordEnd = "2014-07-02T10:45Z"
$coordFrequency = "1440"    # in minutes, 24h x 60m = 1440m
$coordTimezone = "UTC"  #UTC/GMT

#Oozie WF variables
$oozieWFPath="$storageUri/oozie"  # The default name is workflow.xml. And you don't need to specify the file name.
$waitTimeBetweenOozieJobStatusCheck=45


$passwd = ConvertTo-SecureString $clusterPassword -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($clusterUsername, $passwd)



#OoziePayload used for Oozie web service submission
$OoziePayload =  @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

   <property>
       <name>nameNode</name>
       <value>$storageUri</value>
   </property>

   <property>
       <name>jobTracker</name>
       <value>jobtrackerhost:9010</value>
   </property>

   <property>
       <name>queueName</name>
       <value>default</value>
   </property>

   <property>
       <name>oozie.use.system.libpath</name>
       <value>true</value>
   </property>

   

   <property>
       <name>coordStart</name>
       <value>$coordStart</value>
   </property>

   <property>
       <name>coordEnd</name>
       <value>$coordEnd</value>
   </property>

   <property>
       <name>coordFrequency</name>
       <value>$coordFrequency</value>
   </property>

   <property>
       <name>coordTimezone</name>
       <value>$coordTimezone</value>
   </property>

   <property>
       <name>hiveScript</name>
       <value>$hiveScript</value>
   </property>

   <property>
       <name>user.name</name>
       <value>admin</value>
   </property>

    <property>
       <name>oozie.coord.application.path</name>
       <value>$oozieWFPath</value>
    </property>


</configuration>
"@


Write-Host "Checking Oozie server status..." -ForegroundColor Green
$clusterUriStatus = "https://$clusterName.azurehdinsight.net:443/oozie/v2/admin/status"
$response = Invoke-RestMethod -Method Get -Uri $clusterUriStatus -Credential $creds -OutVariable $OozieServerStatus 

$jsonResponse = ConvertFrom-Json (ConvertTo-Json -InputObject $response)
$oozieServerSatus = $jsonResponse[0].("systemMode")
Write-Host "Oozie server status is $oozieServerSatus..."
if($oozieServerSatus -notmatch "NORMAL")
{
    Write-Host "Oozie server status is $oozieServerSatus...cannot submit Oozie jobs. Check the server status and re-run the job."
    exit 1
}

# create Oozie job
Write-Host "Sending the following Payload to the cluster:" -ForegroundColor Green
Write-Host "`n--------`n$OoziePayload`n--------"
$clusterUriCreateJob = "https://$clusterName.azurehdinsight.net:443/oozie/v2/jobs"
$response = Invoke-RestMethod -Method Post -Uri $clusterUriCreateJob -Credential $creds -Body $OoziePayload -ContentType "application/xml" -OutVariable $OozieJobName #-debug

$jsonResponse = ConvertFrom-Json (ConvertTo-Json -InputObject $response)
$oozieJobId = $jsonResponse[0].("id")
Write-Host "Oozie job id is $oozieJobId..." -ForegroundColor Green



# get job status
Write-Host "Sleeping for $waitTimeBetweenOozieJobStatusCheck seconds until the job metadata is populated in the Oozie metastore..." -ForegroundColor Green
Start-Sleep -Seconds $waitTimeBetweenOozieJobStatusCheck

Write-Host "Getting job status and waiting for the job to complete..." -ForegroundColor Green
Write-Host "Oozie JobId: $oozieJobId" -ForegroundColor Green
$clusterUriGetJobStatus = "https://$clusterName.azurehdinsight.net:443/oozie/v2/job/" + $oozieJobId + "?show=info"
$response = Invoke-RestMethod -Method Get -Uri $clusterUriGetJobStatus -Credential $creds 
$jsonResponse = ConvertFrom-Json (ConvertTo-Json -InputObject $response)
$JobStatus = $jsonResponse[0].("status")

while($JobStatus -notmatch "SUCCEEDED|KILLED")
{
    Write-Host "$(Get-Date -format 'G'): $oozieJobId is in $JobStatus state...waiting $waitTimeBetweenOozieJobStatusCheck seconds for the job to complete..."
    Start-Sleep -Seconds $waitTimeBetweenOozieJobStatusCheck
    $response = Invoke-RestMethod -Method Get -Uri $clusterUriGetJobStatus -Credential $creds 
    $jsonResponse = ConvertFrom-Json (ConvertTo-Json -InputObject $response)
    $JobStatus = $jsonResponse[0].("status")
}

Write-Host "$(Get-Date -format 'G'): $oozieJobId is in $JobStatus state!" -ForegroundColor Green
Write-Host "Job: $oozieJobId finished at $(Get-Date -format 'G')" -ForegroundColor Green

if($JobStatus -notmatch "SUCCEEDED")
    {
        Write-Host "Job DID NOT succeed.`nCheck logs at http://headnode0:9014/cluster for detais."
    }


