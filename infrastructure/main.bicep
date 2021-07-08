param deploymentNameSuffix string

@description('The storage accout sku to provision.  Optional, defaults to Standard_LRS')
param storageAccountSkuName string = 'Standard_LRS'

@description('Storage accout sku tier.  Optional, defaults to Standard')
param storageSkuTier string = 'Standard'

@description('Access tier for storage account.  Optional, defaults to Hot')
param storageAccessTier string = 'Hot'

@description('The name of the storage account to provision for Web Job storage')
param webJobsStorageAccountName string

@description('the name of the storage account to provision for report storage')
param reportingStorageAccountName string

@description('The name of the queue to create for report creation requests')
param reportRequestQueueName string

@description('The name of the Web App to provision')
param appServiceName string

@description('The SKU name for the Web App')
param appServiceSkuName string

@description('The capacity for the Web App SKU')
param appServiceSkuCapacity int

var location = resourceGroup().location

module webjobStorage 'modules/storageAccount.bicep' = {
  name: 'webjobsStorage${deploymentNameSuffix}'
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: webJobsStorageAccountName
  }
}

module reportingStorage 'modules/storageAccount.bicep' = {
  name: 'reportingStorage${deploymentNameSuffix}'
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: reportingStorageAccountName
  }
}

module reportQueue 'modules/storageQueue.bicep' = {
  name: 'reportQueue${deploymentNameSuffix}'
  params: {
    queueName: reportRequestQueueName
    storageAccountName: reportingStorageAccountName
  }
  dependsOn: [
    reportingStorage // Manual dependsOn required here because the modules are not aware of each other
  ]
}

module appService 'modules/appService.bicep' = {
  name: 'appService${deploymentNameSuffix}'
  params: {
    location: location
    skuName: appServiceSkuName
    skuCapacity: appServiceSkuCapacity
    appName: appServiceName
  }
}
