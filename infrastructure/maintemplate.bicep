param deploymentNameSuffix string

@description('The storage accout sku to provision.  Optional, defaults to Standard_LRS')
param storageAccountSkuName string = 'Standard_LRS'

@description('Storage accout sku tier.  Optional, defaults to Standard')
param storageSkuTier string = 'Standard'

@description('Access tier for storage account.  Optional, defaults to Hot')
param storageAccessTier string = 'Hot'

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

@description('Indicates whether App Insights and Log Analytics resources should be created.  Optional, defaults to true.')
param createAppInsights bool = true

@description('Name of the Log Analytics workspace to provision')
param logAnalticsWorkspaceName string

@description('Name of the App Insights resource to provision')
param appInsightsName string

@description('The name of the Function app to create')
param functionAppName string

@description('The name of the App Insights resource to create for the Function app')
param functionAppAppInsightsName string

@description('The name of the storage account to create for the Function app')
param functionAppStorageAccountName string

@description('Flag indicating whether or not to create staging deployment slots on the web app and function app')
param createStagingSlots bool = false

@description('Nname for the staging slot.  Defaults to staging')
param stagingSlotName string = 'staging'

var location = resourceGroup().location
var reportingStorageDeploymentName = '${reportingStorageAccountName}-${deploymentNameSuffix}'
var reportQueueDeploymentName = '${reportRequestQueueName}-${deploymentNameSuffix}'
var appServiceDeploymentName = '${appServiceName}-${deploymentNameSuffix}'
var keyVaultDeploymentName = '${keyVaultName}-${deploymentNameSuffix}'
var logAnalyticsDeploymentName = '${logAnalticsWorkspaceName}-${deploymentNameSuffix}'
var appInsightsDeploymentName = '${appInsightsName}-${deploymentNameSuffix}'
var functionAppAppInsightsDeploymentName = '${functionAppAppInsightsName}-${deploymentNameSuffix}'
var functionAppDeploymentName = '${functionAppName}-${deploymentNameSuffix}'

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
    enableAppInsights: createAppInsights
    appInsightsInstrumentationKey: createAppInsights ? appInsights.outputs.appInsightsInstrumentationKey : any(null)
    createStagingSlot: createStagingSlots
    stagingSlotName: stagingSlotName
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

module logAnalytics 'modules/logAnalytics.bicep' = if(createAppInsights) {
  name: logAnalyticsDeploymentName
  params: {
    workspaceName: logAnalticsWorkspaceName
    location: location
  }
}

module appInsights 'modules/appInsigts.bicep' = if(createAppInsights) {
  name: appInsightsDeploymentName
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}

module functionAppAppInsights 'modules/appInsigts.bicep' = if(createAppInsights) {
  name: functionAppAppInsightsDeploymentName
  params: {
    appInsightsName: functionAppAppInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}

module functionApp 'modules/functionApp.bicep' = {
  name: functionAppDeploymentName
  params: {
    functionAppName: functionAppName
    location: location
    storageAccountName: functionAppStorageAccountName
    appInsightsKey: functionAppAppInsights.outputs.appInsightsInstrumentationKey
    createStagingSlot: createStagingSlots
    stagingSlotName: stagingSlotName
  }
}
