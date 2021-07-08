param storageAccountSkuName string = 'Standard_LRS'
param storageSkuTier string = 'Standard'
param storageAccessTier string = 'Hot'
param webjobsStorageAccountName string
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
    storageAccountName: webjobsStorageAccountName
  }
}

module reportingStorage 'modules/storageAccount.bicep' = {
  name: reportingStorageAccountName
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageAccessTier
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
}
