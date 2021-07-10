param skuName string
param skuCapacity int
param location string
param appName string
param enableAppInsights bool
param appInsightsInstrumentationKey string = any(null)

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

resource appServiceAppSettings 'Microsoft.Web/sites/config@2020-06-01' = if(enableAppInsights) {
  name: '${appService.name}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
  }
}

resource appServiceSiteExtension 'Microsoft.Web/sites/siteextensions@2020-06-01' = if(enableAppInsights) {
  name: '${appService.name}/Microsoft.ApplicationInsights.AzureWebsites'  
}
