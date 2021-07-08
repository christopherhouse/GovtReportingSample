param storageAccountSkuName string = 'Standard_LRS'
param storageSkuTier string = 'Standard'
param storageAccessTier string = 'Hot'
param webJobsStorageAccountName string
param reportingStorageAccountName string
param reportRequestQueueName string

var location = resourceGroup().location

module webjobStorage 'modules/storageAccount.bicep' = {
  name: 'webjobsStorage'
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: webJobsStorageAccountName
  }
}

module reportingStorage 'modules/storageAccount.bicep' = {
  name: 'reportingStorage'
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: reportingStorageAccountName
  }
}

module reportQueue 'modules/storageQueue.bicep' = {
  name: 'reportQueue'
  params: {
    queueName: reportRequestQueueName
    storageAccountName: reportingStorageAccountName
  }
  dependsOn: [
    reportingStorage // Manual dependsOn required here because the modules are not aware of each other
  ]
}
