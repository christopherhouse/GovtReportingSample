param storageAccountName string
param location string
param skuName string
param skuTier string
param storageAccessTier string

resource storage 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  kind: 'StorageV2'
  properties: {
    accessTier: storageAccessTier
  }
}
