param skuName string
param skuCapacity int
param location string
param appName string
param enableAppInsights bool
param appInsightsInstrumentationKey string = any(null)
param createStagingSlot bool = false
param stagingSlotName string = 'staging'

var appServicePlanName = 'asp-${appName}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource appServiceAppSettings 'Microsoft.Web/sites/config@2021-01-15' = if(enableAppInsights) {
  name: '${appService.name}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
  }
}

resource appServiceSiteExtension 'Microsoft.Web/sites/siteextensions@2020-06-01' = if(enableAppInsights) {
  name: '${appService.name}/Microsoft.ApplicationInsights.AzureWebsites'  
}

resource stagingSlot 'Microsoft.Web/sites/slots@2021-01-15' = if(createStagingSlot) {
  name: '${appService.name}/${stagingSlotName}'
  location: location
  kind: 'webapp'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource stagingSlotAppConfig 'Microsoft.Web/sites/config@2021-01-15' = if(enableAppInsights && createStagingSlot) {
  name: '${stagingSlot.name}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
  }
}
