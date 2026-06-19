targetScope = 'resourceGroup'

resource registry 'Microsoft.ContainerRegistry/registries@2026-01-01-preview' existing = {
  name: 'qzqabotcontainer'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' existing = {
  name: 'qzqabotstorage'
}

resource roleAssignment2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignment3 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource vault 'Microsoft.KeyVault/vaults@2026-03-01-preview' existing = {
  name: 'qzqabot-keyvalut'
}

resource roleAssignment4 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: vault
  name: guid(vault.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2025-08-01-preview' existing = {
  name: 'qzqabot-config'
}

resource roleAssignment5 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: configurationStore
  name: guid(configurationStore.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource searchService 'Microsoft.Search/searchServices@2026-03-01-preview' existing = {
  name: 'qzqabot-search'
}

resource roleAssignment6 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: searchService
  name: guid(searchService.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1407120a-92aa-4202-b7e9-c0e197c71c8f'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1407120a-92aa-4202-b7e9-c0e197c71c8f')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource account 'Microsoft.CognitiveServices/accounts@2026-05-01' existing = {
  name: 'qzqabot-ai-resource'
}

resource roleAssignment7 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: account
  name: guid(account.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd')
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    principalType: 'ServicePrincipal'
  }
}

resource serverfarm 'Microsoft.Web/serverfarms@2025-05-01' = {
  name: 'azuresdkqabot-appserviceplan'
  location: 'West US 2'
  properties: {
    reserved: true
  }
  sku: {
    name: 'P0v3'
    tier: 'Premium0V3'
    size: 'P0v3'
    family: 'Pv3'
    capacity: 1
  }
  kind: 'linux'
}

resource component 'Microsoft.Insights/components@2020-02-02' = {
  name: 'azuresdkqabot-server'
  location: 'westus2'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    WorkspaceResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/defaultresourcegroup-wus2/providers/microsoft.operationalinsights/workspaces/defaultworkspace-faa080af-c1d8-40ad-9cce-e1a450ca5b57-wus2'
  }
}

resource component2 'Microsoft.Insights/components@2020-02-02' = {
  name: 'azuresdkqabot-server202510300250'
  location: 'westus2'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    WorkspaceResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/defaultresourcegroup-wus2/providers/microsoft.operationalinsights/workspaces/defaultworkspace-faa080af-c1d8-40ad-9cce-e1a450ca5b57-wus2'
  }
}

resource site 'Microsoft.Web/sites@2025-05-01' = {
  name: 'azuresdkqabot-server'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/microsoft.insights/components/azuresdkqabot-server202510300250'
  }
  location: 'West US 2'
  properties: {
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    serverFarmId: serverfarm.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|qzqabotcontainer.azurecr.io/azure-sdk-qa-bot-backend:latest'
      alwaysOn: true
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
          name: 'AZURE_RESOURCE_GROUP'
          value: 'azure-sdk-qa-bot'
        }
        {
          name: 'AI_PROJECT_NAME'
          value: 'qzqabot-ai'
        }
        {
          name: 'AZURE_AI_RESOURCE_NAME'
          value: 'qzqabot-ai-resource'
        }
        {
          name: 'APP_INSIGHTS_CONNECTION_STRING'
          value: ''
        }
        {
          name: 'AZURE_SEARCH_SERVICE_NAME'
          value: 'qzqabot-search'
        }
        {
          name: 'COSMOS_DB_ACCOUNT_NAME'
          value: 'qzqabot-db'
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
      ]
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.ManagedIdentity/userAssignedIdentities/qzqabot-identity': {}
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azsdkqabot': {}
    }
  }
  kind: 'app,linux,container'
}

resource config 'Microsoft.Web/sites/config@2025-05-01' = {
  name: 'authsettingsV2'
  parent: site
  properties: {
    platform: {
      enabled: true
      runtimeVersion: '~1'
    }
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'RedirectToLoginPage'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          clientId: ''
          openIdIssuer: 'https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/v2.0'
        }
        login: {
          loginParameters: []
        }
      }
    }
    login: {
      tokenStore: {
        enabled: true
      }
    }
  }
}

resource sitecontainer 'Microsoft.Web/sites/sitecontainers@2025-05-01' = {
  name: 'main'
  parent: site
  properties: {
    image: 'mcr.microsoft.com/appsvc/staticsite:latest'
    targetPort: '80'
    isMain: true
    authType: 'Anonymous'
    volumeMounts: []
    environmentVariables: []
  }
}

resource slot 'Microsoft.Web/sites/slots@2025-05-01' = {
  name: 'agent'
  parent: site
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/microsoft.insights/components/azuresdkqabot-server202510300250'
  }
  location: 'West US 2'
  properties: {
    serverFarmId: serverfarm.id
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    siteConfig: {
      linuxFxVersion: 'DOCKER|qzqabotcontainer.azurecr.io/azure-sdk-qa-bot-agent-server:latest'
      alwaysOn: true
      acrUseManagedIdentityCreds: true
      ftpsState: 'FtpsOnly'
      httpLoggingEnabled: false
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
          name: 'AZURE_RESOURCE_GROUP'
          value: 'azure-sdk-qa-bot'
        }
        {
          name: 'AI_PROJECT_NAME'
          value: 'qzqabot-ai'
        }
        {
          name: 'AZURE_AI_RESOURCE_NAME'
          value: 'qzqabot-ai-resource'
        }
        {
          name: 'APP_INSIGHTS_CONNECTION_STRING'
          value: ''
        }
        {
          name: 'COSMOS_DB_ACCOUNT_NAME'
          value: 'qzqabot-db'
        }
        {
          name: 'STORAGE_ACCOUNT_NAME'
          value: 'qzqabotstorage'
        }
      ]
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.ManagedIdentity/userAssignedIdentities/qzqabot-identity': {}
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azsdkqabot': {}
    }
  }
  kind: 'app,linux,container'
}

resource metricAlert 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: 'azuresdkqabot-alert'
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      site.id
    ]
    evaluationFrequency: 'PT1M'
    autoMitigate: true
    targetResourceType: 'Microsoft.Web/sites'
    targetResourceRegion: 'westus2'
    actions: [
      {
        actionGroupId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Insights/actionGroups/azuresdkqabot-alert'
        webHookProperties: {}
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: 0
          name: 'Metric1'
          metricNamespace: 'Microsoft.Web/sites'
          metricName: 'Http5xx'
          dimensions: []
          timeAggregation: 'Total'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
  }
}

resource metricAlert2 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: 'azuresdkqabot-agent-alert'
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      slot.id
    ]
    evaluationFrequency: 'PT1M'
    autoMitigate: true
    targetResourceType: 'Microsoft.Web/sites/slots'
    targetResourceRegion: 'westus2'
    actions: [
      {
        actionGroupId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Insights/actionGroups/azuresdkqabot-alert'
        webHookProperties: {}
      }
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: 0
          name: 'Metric1'
          metricNamespace: 'Microsoft.Web/sites/slots'
          metricName: 'Http5xx'
          dimensions: []
          timeAggregation: 'Total'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
  }
}
