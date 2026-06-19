targetScope = 'resourceGroup'

resource serverfarm 'Microsoft.Web/serverfarms@2025-05-01' = {
  name: 'azuresdkqabot-functionserviceplan'
  location: 'West US 2'
  properties: {
    elasticScaleEnabled: true
    maximumElasticWorkerCount: 20
    reserved: true
  }
  sku: {
    name: 'EP1'
    tier: 'ElasticPremium'
    size: 'EP1'
    family: 'EP'
    capacity: 1
  }
  kind: 'elastic'
}

resource component 'Microsoft.Insights/components@2020-02-02' = {
  name: 'azuresdkqabot-function'
  location: 'westus2'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    WorkspaceResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/defaultresourcegroup-wus2/providers/microsoft.operationalinsights/workspaces/defaultworkspace-faa080af-c1d8-40ad-9cce-e1a450ca5b57-wus2'
  }
}

resource site 'Microsoft.Web/sites@2025-05-01' = {
  name: 'azuresdkqabot-function'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/microsoft.insights/components/azuresdkqabot-function'
  }
  location: 'West US 2'
  properties: {
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    serverFarmId: serverfarm.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|qzqabotcontainer.azurecr.io/azure-sdk-qa-bot-function:latest'
      alwaysOn: false
      acrUseManagedIdentityCreds: true
      ftpsState: 'FtpsOnly'
      httpLoggingEnabled: false
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'AZURE_CLIENT_ID'
          value: ''
        }
        {
          name: 'AZURE_TENANT_ID'
          value: ''
        }
        {
          name: 'AZURE_SUBSCRIPTION_ID'
          value: 'faa080af-c1d8-40ad-9cce-e1a450ca5b57'
        }
        {
          name: 'STORAGE_ACCOUNT_NAME'
          value: 'qzqabotstorage'
        }
        {
          name: 'KEY_VAULT_NAME'
          value: 'qzqabot-keyvalut'
        }
        {
          name: 'APP_CONFIG_NAME'
          value: 'qzqabot-config'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: ''
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: ''
        }
        {
          name: 'AzureWebJobsStorage'
          value: ''
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: ''
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'azuresdkqabot-function'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
        supportCredentials: false
      }
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.ManagedIdentity/userAssignedIdentities/qzqabot-identity': {}
    }
  }
  kind: 'functionapp,linux,container'
}

resource function 'Microsoft.Web/sites/functions@2025-05-01' = {
  name: 'adoTokenRefresh'
  parent: site
  properties: {
    script_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/site/wwwroot/index.js'
    test_data_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/data/Functions/sampledata/adoTokenRefresh.dat'
    href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/functions/adoTokenRefresh'
    language: 'node'
    isDisabled: false
  }
}

resource function2 'Microsoft.Web/sites/functions@2025-05-01' = {
  name: 'channels'
  parent: site
  properties: {
    script_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/site/wwwroot/index.js'
    test_data_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/data/Functions/sampledata/channels.dat'
    href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/functions/channels'
    invoke_url_template: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/api/channels'
    language: 'node'
    isDisabled: false
  }
}

resource function3 'Microsoft.Web/sites/functions@2025-05-01' = {
  name: 'convertActivity'
  parent: site
  properties: {
    script_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/site/wwwroot/index.js'
    test_data_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/data/Functions/sampledata/convertActivity.dat'
    href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/functions/convertActivity'
    invoke_url_template: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/api/convertactivity'
    language: 'node'
    isDisabled: false
  }
}

resource function4 'Microsoft.Web/sites/functions@2025-05-01' = {
  name: 'feedbacks'
  parent: site
  properties: {
    script_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/site/wwwroot/index.js'
    test_data_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/data/Functions/sampledata/feedbacks.dat'
    href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/functions/feedbacks'
    invoke_url_template: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/api/feedbacks'
    language: 'node'
    isDisabled: false
  }
}

resource function5 'Microsoft.Web/sites/functions@2025-05-01' = {
  name: 'records'
  parent: site
  properties: {
    script_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/site/wwwroot/index.js'
    test_data_href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/vfs/home/data/Functions/sampledata/records.dat'
    href: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/admin/functions/records'
    invoke_url_template: 'https://azuresdkqabot-function-apa6h3fnf5hye9gc.westus2-01.azurewebsites.net/api/records'
    language: 'node'
    isDisabled: false
  }
}
