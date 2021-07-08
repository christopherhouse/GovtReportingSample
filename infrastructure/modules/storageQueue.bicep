param storageAccountName string
param queueName string

var fullQueueName = '${storageAccountName}/${queueName}'

resource storageQueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-01-01' = {
  name: fullQueueName
}
