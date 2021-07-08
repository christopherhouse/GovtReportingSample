param keyVaultName string
param location string
param sku string = 'Standard'
param tenantId string
param softDeleteRetentionInDays int = 90
param accessPolicyTargetObjectId string


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
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: accessPolicyTargetObjectId
        permissions: {
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
          ]
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'ManageContacts'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
          ]
        }
      }
    ]
  }
}
