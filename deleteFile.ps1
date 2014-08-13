$subscriptionName = "Telesales Reporting - Dev"
$containerName = "crmhivecluster"
$storageAccountName = "crmhivestorage"
   
Select-AzureSubscription $subscriptionName

Write-Host "Create a context object ... " -ForegroundColor Green
$storageAccountKey = Get-AzureStorageKey $storageAccountName | %{ $_.Primary }
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey  

$blob = "PhoneCallBase\000000_0"

Write-Host "Delete the blob ..." -ForegroundColor Green
Remove-AzureStorageBlob -Container $containerName -Context $storageContext -blob $blob



