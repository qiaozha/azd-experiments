targetScope = 'resourceGroup'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-05-31-preview' = {
  name: 'qzqabot-identity'
  location: 'westus2'
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: 'qzqabot-log'
  location: 'westus2'
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource actionGroup 'Microsoft.Insights/actionGroups@2024-10-01-preview' = {
  name: 'qzqabot-alert'
  location: 'Global'
  properties: {
    groupShortName: 'Alert'
    emailReceivers: [
      {
        name: 'Email0_-EmailAction-'
        emailAddress: 'azuresdkqabotproject@service.microsoft.com'
        useCommonAlertSchema: true
      }
    ]
  }
}

resource vault 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  name: 'qzqabot-keyvalut'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '72f988bf-86f1-41af-91ab-2d7cd011db47'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Allow'
    }
    accessPolicies: []
  }
  location: 'westus2'
}

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2025-08-01-preview' = {
  name: 'qzqabot-config'
  location: 'westus2'
  properties: {
    encryption: {}
    disableLocalAuth: true
    defaultKeyValueRevisionRetentionPeriodInSeconds: 2592000
    dataPlaneProxy: {
      authenticationMode: 'Local'
      privateLinkDelegation: 'Disabled'
    }
    telemetry: {}
    azureFrontDoor: {}
  }
  sku: {
    name: 'standard'
  }
}

resource searchService 'Microsoft.Search/searchServices@2026-03-01-preview' = {
  name: 'qzqabot-search'
  location: 'West US 2'
  properties: {
    computeType: 'Default'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    dataExfiltrationProtections: []
    semanticSearch: 'standard'
    knowledgeRetrieval: 'free'
  }
  sku: {
    name: 'standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2026-01-01-preview' = {
  name: 'qzqabotcontainer'
  location: 'westus2'
  sku: {
    name: 'Standard'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: 'qzqabotstorage'
  location: 'westus2'
  properties: {
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    largeFileSharesState: 'Enabled'
    networkAcls: {
      virtualNetworkRules: []
      ipRules: []
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
    }
    accessTier: 'Hot'
  }
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    isVersioningEnabled: false
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  name: 'bot-configs'
  parent: blobService
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource container2 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  name: 'evaluation-dataset'
  parent: blobService
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource container3 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  name: 'feedback'
  parent: blobService
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource container4 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  name: 'knowledge'
  parent: blobService
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource container5 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  name: 'records'
  parent: blobService
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  name: 'default'
  parent: storageAccount
}

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2026-04-01' = {
  name: 'TeamsChannelConversationsDev'
  parent: tableService
}

resource table2 'Microsoft.Storage/storageAccounts/tableServices/tables@2026-04-01' = {
  name: 'TeamsChannelConversationsProd'
  parent: tableService
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2026-03-15' = {
  name: 'qzqabot-db'
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: true
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: true
    enablePartitionMerge: false
    enableBurstCapacity: false
    minimalTlsVersion: 'Tls12'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: 'West US 2'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: []
    ipRules: []
    backupPolicy: {
      type: 'Continuous'
      continuousModeProperties: {
        tier: 'Continuous7Days'
      }
    }
    networkAclBypassResourceIds: []
  }
  location: 'West US 2'
  tags: {
    defaultExperience: 'Core (SQL)'
    'hidden-workload-type': 'Development/Testing'
    'hidden-cosmos-mmspecial': ''
  }
  identity: {
    type: 'None'
  }
  kind: 'GlobalDocumentDB'
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2026-03-15' = {
  name: 'azure-sdk-qa-bot'
  parent: databaseAccount
  properties: {
    resource: {
      id: 'azure-sdk-qa-bot'
    }
  }
}

resource container6 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2026-03-15' = {
  name: 'conversation-mappings'
  parent: sqlDatabase
  properties: {
    resource: {
      id: 'conversation-mappings'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/conversationId'
        ]
        kind: 'Hash'
        version: 2
      }
    }
  }
}

resource container7 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2026-03-15' = {
  name: 'conversation-messages'
  parent: sqlDatabase
  properties: {
    resource: {
      id: 'conversation-messages'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/conversationId'
        ]
        kind: 'Hash'
        version: 2
      }
    }
  }
}

resource container8 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2026-03-15' = {
  name: 'experience-episodes'
  parent: sqlDatabase
  properties: {
    resource: {
      id: 'experience-episodes'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/episodeId'
        ]
        kind: 'Hash'
        version: 2
      }
    }
  }
}

resource container9 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2026-03-15' = {
  name: 'thread-mappings'
  parent: sqlDatabase
  properties: {
    resource: {
      id: 'thread-mappings'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/threadId'
        ]
        kind: 'Hash'
        version: 2
      }
    }
  }
}

resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2026-03-15' = {
  name: '00000000-0000-0000-0000-000000000001'
  parent: databaseAccount
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource sqlRoleDefinition2 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2026-03-15' = {
  name: '00000000-0000-0000-0000-000000000002'
  parent: databaseAccount
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2026-03-15' = {
  name: '19f1f6af-0515-4660-afdb-e3b5a7001e67'
  parent: databaseAccount
  properties: {
    roleDefinitionId: sqlRoleDefinition2.id
    principalId: 'd14612b2-da23-4c06-ab30-88b5d65dae0c'
    scope: databaseAccount.id
  }
}

resource sqlRoleAssignment2 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2026-03-15' = {
  name: '6e24aed8-31e5-4705-9bc1-a882a89703e9'
  parent: databaseAccount
  properties: {
    roleDefinitionId: sqlRoleDefinition2.id
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    scope: databaseAccount.id
  }
}

resource tableRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2026-03-15' = {
  name: '00000000-0000-0000-0000-000000000001'
  parent: databaseAccount
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource tableRoleDefinition2 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2026-03-15' = {
  name: '00000000-0000-0000-0000-000000000002'
  parent: databaseAccount
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource tableRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/tableRoleAssignments@2026-03-15' = {
  name: '2af1f6af-0515-4660-afdb-e3b5a7001e68'
  parent: databaseAccount
  properties: {
    roleDefinitionId: tableRoleDefinition2.id
    principalId: 'd14612b2-da23-4c06-ab30-88b5d65dae0c'
    scope: databaseAccount.id
  }
}

resource tableRoleAssignment2 'Microsoft.DocumentDB/databaseAccounts/tableRoleAssignments@2026-03-15' = {
  name: '7e35aed8-31e5-4705-9bc1-a882a89703ea'
  parent: databaseAccount
  properties: {
    roleDefinitionId: tableRoleDefinition2.id
    principalId: '5589cee8-16a1-4389-b142-86706adc5c9f'
    scope: databaseAccount.id
  }
}
