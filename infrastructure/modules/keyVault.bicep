param keyVaultName string
param location string
param sku string = 'Standard'
param tenantId string
param softDeleteRetentionInDays int = 90

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: sku
    }
    softDeleteRetentionInDays: softDeleteRetentionInDays
  }
}
