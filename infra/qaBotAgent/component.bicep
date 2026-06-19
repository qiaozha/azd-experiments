targetScope = 'resourceGroup'

resource component 'Microsoft.Insights/components@2020-02-02' = {
  name: 'qzqabot-agent'
  location: 'eastus'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
    RetentionInDays: 90
    WorkspaceResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.OperationalInsights/workspaces/qzqabot-log'
  }
}

resource metricAlert 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: 'qzqabot-agent-alert'
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Web/sites/azuresdkqabot-server/slots/agent'
    ]
    evaluationFrequency: 'PT1M'
    autoMitigate: true
    targetResourceType: 'Microsoft.Web/sites/slots'
    targetResourceRegion: 'westus2'
    actions: [
      {
        actionGroupId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Insights/actionGroups/qzqabot-alert'
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

resource account 'Microsoft.CognitiveServices/accounts@2026-05-01' = {
  name: 'qzqabot-ai-resource'
  properties: {
    apiProperties: {}
    customSubDomainName: 'qzqabot-ai-resource'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    allowProjectManagement: true
    defaultProject: 'qzqabot-ai'
    associatedProjects: [
      'qzqabot-ai'
    ]
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
  }
  location: 'eastus'
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'gpt-4.1'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4.1'
      version: '2025-04-14'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 1
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource deployment2 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'gpt-4.1-mini'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4.1-mini'
      version: '2025-04-14'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 1
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource deployment3 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'gpt-5.4'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-5.4'
      version: '2026-03-05'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 1
    serviceTier: 'Default'
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource deployment4 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'gpt-5-mini'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-5-mini'
      version: '2025-08-07'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 1
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource deployment5 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'o4-mini'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'o4-mini'
      version: '2025-04-16'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 1
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource deployment6 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  name: 'text-embedding-ada-002'
  parent: account
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
    versionUpgradeOption: 'NoAutoUpgrade'
    currentCapacity: 1
    deploymentState: 'Running'
  }
  sku: {
    name: 'GlobalStandard'
    capacity: 1
  }
}

resource connection 'Microsoft.CognitiveServices/accounts/connections@2026-05-01' = {
  name: 'qzqabotstorage'
  parent: account
  properties: {
    authType: 'AAD'
    category: 'AzureStorageAccount'
    target: 'https://qzqabotstorage.blob.core.windows.net/'
    useWorkspaceManagedIdentity: false
    isSharedToAll: false
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Storage/storageAccounts/qzqabotstorage'
    }
  }
}

resource capabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2026-05-01' = {
  name: 'default'
  parent: account
  properties: {
    capabilityHostKind: 'Agents'
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2026-05-01' = {
  name: 'qzqabot-ai'
  parent: account
  properties: {}
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
}

resource connection2 'Microsoft.CognitiveServices/accounts/projects/connections@2026-05-01' = {
  name: 'qzqabotstorage'
  parent: project
  properties: {
    authType: 'AAD'
    category: 'AzureStorageAccount'
    target: 'https://qzqabotstorage.blob.core.windows.net/'
    useWorkspaceManagedIdentity: false
    isSharedToAll: false
    sharedUserList: []
    peRequirement: 'NotRequired'
    peStatus: 'NotApplicable'
    metadata: {
      ApiType: 'Azure'
      ResourceId: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/resourceGroups/azure-sdk-qa-bot/providers/Microsoft.Storage/storageAccounts/qzqabotstorage'
    }
  }
}
