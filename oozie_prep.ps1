# WASB variables
$storageAccountName = "crmhivestorage"
$containerName = "crmhivecluster"

# Local paths
$workflowDefinition = "C:\Users\t-ankigu\Documents\HDInsight\oozie\workflow.xml"
$coordDefinition =  "C:\Users\t-ankigu\Documents\HDInsight\oozie\coordinator.xml"

# $opportunityScript = "C:\Users\t-ankigu\Documents\HDInsight\oozie\opportunityquery.hql"
# $accountScript = "C:\Users\t-ankigu\Documents\HDInsight\oozie\accountquery.hql"
# $leadScript = "C:\Users\t-ankigu\Documents\HDInsight\oozie\leadquery.hql"
# $contactScript = "C:\Users\t-ankigu\Documents\HDInsight\oozie\contactquery.hql"
$activityPointerScript = "C:\Users\t-ankigu\Documents\Scripts\AzureEtlUtilities\activitypointerbase_query.hql"
$phoneCallScript = "C:\Users\t-ankigu\Documents\Scripts\AzureEtlUtilities\phonecallbase_query.hql"


# Wasb dest folder
$destFolder = "oozie"

# Cluster credentials
$storageaccountkey = get-azurestoragekey $storageAccountName | %{$_.Primary}
$destContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageaccountkey


# Upload Files
Write-Host "Copy workflow definition, HiveQL, and Coordinator script file ..." -ForegroundColor Green

Set-AzureStorageBlobContent -File $coordDefinition -Container $containerName -Blob "$destFolder/coordinator.xml" -Context $destContext
y
Set-AzureStorageBlobContent -File $workflowDefinition -Container $containerName -Blob "$destFolder/workflow.xml" -Context $destContext
y

# Set-AzureStorageBlobContent -File $opportunityScript -Container $containerName -Blob "$destFolder/opportunityquery.hql" -Context $destContext
# Set-AzureStorageBlobContent -File $accountScript -Container $containerName -Blob "$destFolder/accountquery.hql" -Context $destContext
# Set-AzureStorageBlobContent -File $leadScript -Container $containerName -Blob "$destFolder/leadquery.hql" -Context $destContext
# Set-AzureStorageBlobContent -File $contactScript -Container $containerName -Blob "$destFolder/contactquery.hql" -Context $destContext

Set-AzureStorageBlobContent -File $activityPointerScript -Container $containerName -Blob "$destFolder/activitypointerbase_query.hql" -Context $destContext
y
Set-AzureStorageBlobContent -File $phoneCallScript -Container $containerName -Blob "$destFolder/phonecallbase_query.hql" -Context $destContext
y

