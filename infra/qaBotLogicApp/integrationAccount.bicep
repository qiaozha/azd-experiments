targetScope = 'resourceGroup'

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' = {
  name: 'azuresdkqabot-ia'
  location: 'westus2'
  sku: {
    name: 'Basic'
  }
  properties: {}
}

resource connection 'Microsoft.Web/connections@2016-06-01' = {
  name: 'teams'
  location: 'westus2'
  properties: {
    displayName: 'teams'
    api: {
      id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/teams'
    }
    parameterValues: {}
  }
}

resource connection2 'Microsoft.Web/connections@2016-06-01' = {
  name: 'azureblob'
  location: 'westus2'
  properties: {
    displayName: 'azureblob'
    api: {
      id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/azureblob'
    }
    parameterValues: {
      accountName: 'qzqabotstorage'
      accessKey: ''
    }
  }
}

resource connection3 'Microsoft.Web/connections@2016-06-01' = {
  name: 'documentdb'
  location: 'westus2'
  properties: {
    displayName: 'documentdb'
    api: {
      id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/documentdb'
    }
    parameterValues: {}
  }
}

resource workflow 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'azuresdkqabot-logicapp'
  location: 'westus2'
  properties: {
    state: 'Enabled'
    integrationAccount: {
      id: integrationAccount.id
    }
    definition: {}
    parameters: {
      '$connections': {
        value: {
          teams: {
            connectionId: connection.id
            connectionName: 'teams'
            id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/teams'
          }
          azureblob: {
            connectionId: connection2.id
            connectionName: 'azureblob'
            id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/azureblob'
          }
          documentdb: {
            connectionId: connection3.id
            connectionName: 'documentdb'
            id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/documentdb'
          }
        }
      }
    }
  }
}

resource workflow2 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'azuresdkqabot-channel-mirror-logicapp'
  location: 'westus2'
  properties: {
    state: 'Enabled'
    definition: {}
    parameters: {
      '$connections': {
        value: {
          teams: {
            connectionId: connection.id
            connectionName: 'teams'
            id: '/subscriptions/faa080af-c1d8-40ad-9cce-e1a450ca5b57/providers/Microsoft.Web/locations/westus2/managedApis/teams'
          }
        }
      }
    }
  }
}

resource metricAlert 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: 'azuresdkqabot-logicapp-alert'
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      workflow.id
    ]
    evaluationFrequency: 'PT1M'
    autoMitigate: true
    targetResourceType: 'Microsoft.Logic/workflows'
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
          metricNamespace: 'Microsoft.Logic/workflows'
          metricName: 'RunsFailed'
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
