@description('Name of the FastAPI application.')
param appName string = 'nhuttu-python'

@description('Location for all resources.')
param location string = 'northeurope'

@description('SKU for the App Service Plan. Example: B1, S1, P1v2.')
param sku string = 'B1'

@description('Python version for the App Service. Example: 3.9, 3.8.')
param pythonVersion string = '3.12'

var skuTierMap = {
  F1: 'Free'
  D1: 'Shared'
  B1: 'Basic'
  B2: 'Basic'
  B3: 'Basic'
  S1: 'Standard'
  S2: 'Standard'
  S3: 'Standard'
  P1v2: 'PremiumV2'
  P2v2: 'PremiumV2'
  P3v2: 'PremiumV2'
}

/**
 * App Service Plan
 */
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${appName}-plan'
  location: location
  kind: 'linux'
  sku: {
    name: sku
    tier: skuTierMap[sku]
    size: sku
    capacity: 1
  }
  properties: {
    reserved: true // Indicates Linux
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}

/**
 * Web App for FastAPI
 */
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|${pythonVersion}'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8000' // Default port for FastAPI
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        // Optional: Add more app settings as needed
      ]
      // Optional: Configure startup command if needed
      // For example, using Uvicorn to run the FastAPI app
      // startupCommand: 'uvicorn main:app --host 0.0.0.0 --port 8000'
    }
    httpsOnly: true
  }
}

/**
 * Output the default hostname of the Web App
 */
output webAppDefaultHostName string = webApp.properties.defaultHostName

