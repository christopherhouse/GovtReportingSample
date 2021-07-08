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

@description('The name of the Key Vault to provision')
param keyVaultName string

@description('Object ID Key Vault access policy will be assigned to')
param accessPolicyTargetObjectId string

var location = resourceGroup().location
var webjobsStorageDeploymentName = '${webJobsStorageAccountName}-${deploymentNameSuffix}'
var reportingStorageDeploymentName = '${reportingStorageAccountName}-${deploymentNameSuffix}'
var reportQueueDeploymentName = '${reportRequestQueueName}-${deploymentNameSuffix}'
var appServiceDeploymentName = '${appServiceName}-${deploymentNameSuffix}'
var keyVaultDeploymentName = '${keyVaultName}-${deploymentNameSuffix}'
module webjobStorage 'modules/storageAccount.bicep' = {
  name: webjobsStorageDeploymentName
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: webJobsStorageAccountName
  }
}

module reportingStorage 'modules/storageAccount.bicep' = {
  name: reportingStorageDeploymentName
  params: {
    location: location
    skuName: storageAccountSkuName
    skuTier: storageSkuTier
    storageAccessTier: storageAccessTier
    storageAccountName: reportingStorageAccountName
  }
}

module reportQueue 'modules/storageQueue.bicep' = {
  name: reportQueueDeploymentName
  params: {
    queueName: reportRequestQueueName
    storageAccountName: reportingStorageAccountName
  }
  dependsOn: [
    reportingStorage // Manual dependsOn required here because the modules are not aware of each other
  ]
}

module appService 'modules/appService.bicep' = {
  name: appServiceDeploymentName
  params: {
    location: location
    skuName: appServiceSkuName
    skuCapacity: appServiceSkuCapacity
    appName: appServiceName
  }
}

module keyVault 'modules/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    keyVaultName: keyVaultName
    tenantId: subscription().tenantId
    location: location
    accessPolicyTargetObjectId: accessPolicyTargetObjectId
  }
}
