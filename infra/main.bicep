// Main azd orchestration template for the QA Bot chatbot service.
// Each Bicep file represents a deployment layer generated from
// packages/demo/qa-bot in the azure-cdk repo. This template deploys
// them in dependency order as Bicep modules.

targetScope = 'subscription'

@description('Azure region for all resources.')
param location string = 'westus2'

@description('Name of the resource group to deploy into.')
param resourceGroupName string = 'azure-sdk-qa-bot'

@description('Teams team (group) ID the Logic App monitors.')
param teamsGroupId string

@description('Teams channel IDs the Logic App subscribes to.')
param teamsChannelIds array

@description('Client ID (audience) for authenticating to the agent server. External Entra app registration.')
param serverAudience string

@description('Function App container image repository and tag (e.g. azure-sdk-qa-bot-function:latest). The registry is taken from the shared Container Registry.')
param functionImageRepository string

@description('Backend container image repository and tag (e.g. azure-sdk-qa-bot-backend:latest). The registry is taken from the shared Container Registry.')
param ragBasedBackendImageRepository string

@description('Agent server (slot) container image repository and tag (e.g. azure-sdk-qa-bot-agent-server:latest). The registry is taken from the shared Container Registry.')
param agentBasedImageRepository string

// ── Resource Group ─────────────────────────────────────────────────────────────
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// ── Layer 1: Shared resources ──────────────────────────────────────────────────
// Creates: managed identity, storage account, container registry, Cosmos DB,
// Key Vault, App Configuration, Search, Log Analytics, action group, and their
// RBAC role assignments. Everything else depends on these foundational resources.
module sharedResources './qaBotSharedResources/sharedResources.bicep' = {
  name: 'shared-resources'
  scope: rg
}

// ── Layer 2: Agent / AI services ───────────────────────────────────────────────
// Creates: Application Insights (agent), Azure AI Services account,
// GPT-4.1 / GPT-4.1-mini / GPT-5.4 / o4-mini / text-embedding model deployments,
// and metric alerts wired to the shared action group.
module agent './qaBotAgent/component.bicep' = {
  name: 'agent'
  scope: rg
  params: {
    managedIdentityPrincipalId: sharedResources.outputs.managedIdentityPrincipalId
    storageAccountName: sharedResources.outputs.storageAccountName
    storageBlobEndpoint: sharedResources.outputs.storageBlobEndpoint
  }
}

// ── Layer 3: Frontend (Teams Bot) ──────────────────────────────────────────────
// Creates: managed identity, Log Analytics workspace, Application Insights,
// Container Registry, App Service Plan, App Service (bot container),
// Bot Service + Teams channel, web test, metric alerts, delete lock,
// and invokes the storage-permissions sub-module for cross-RG role assignments.
// Deployed before the backend because the backend attaches this module's
// managed identity (botIdentityName) to its site/slot.
module frontend './qaBotFrontend/userAssignedIdentity.bicep' = {
  name: 'frontend'
  scope: rg
  dependsOn: [sharedResources]
}

// ── Layer 4: Backend (App Service) ─────────────────────────────────────────────
// Creates: App Service Plan, App Service (backend container), the 'agent' slot
// (agent-server container), Application Insights, and metric alerts.
module backend './qaBotBackend/serverfarm.bicep' = {
  name: 'backend'
  scope: rg
  params: {
    location: location
    ragBasedBackendImage: '${sharedResources.outputs.containerRegistryLoginServer}/${ragBasedBackendImageRepository}'
    agentBasedBackendImage: '${sharedResources.outputs.containerRegistryLoginServer}/${agentBasedImageRepository}'
    managedIdentityClientId: sharedResources.outputs.managedIdentityClientId
    serverAudience: serverAudience
    sharedIdentityName: sharedResources.outputs.managedIdentityName
    frontendIdentityName: frontend.outputs.botIdentityName
    aiResourceName: agent.outputs.aiResourceName
    aiProjectName: agent.outputs.aiProjectName
    searchServiceName: sharedResources.outputs.searchServiceName
    cosmosDbAccountName: sharedResources.outputs.cosmosDbAccountName
    storageAccountName: sharedResources.outputs.storageAccountName
    keyVaultName: sharedResources.outputs.keyVaultName
    appConfigName: sharedResources.outputs.appConfigName
    actionGroupName: sharedResources.outputs.actionGroupName
  }
}

// ── Layer 5: Function App ───────────────────────────────────────────────────────
// Creates: Elastic Premium App Service Plan, Application Insights,
// and Function App site running the bot-function Docker container.
module functionApp './qaBotFunctionApp/serverfarm.bicep' = {
  name: 'function-app'
  scope: rg
  params: {
    location: location
    containerImage: '${sharedResources.outputs.containerRegistryLoginServer}/${functionImageRepository}'
    managedIdentityClientId: sharedResources.outputs.managedIdentityClientId
    managedIdentityResourceId: sharedResources.outputs.managedIdentityResourceId
    storageAccountName: sharedResources.outputs.storageAccountName
  }
}

// ── Layer 6: Logic App ─────────────────────────────────────────────────────────
// Creates: Integration Account, managed API connections (Teams, Azure Blob,
// Cosmos DB), and the Logic App workflow that wires them together.
module logicApp './qaBotLogicApp/logicAppResources.bicep' = {
  name: 'logic-app'
  scope: rg
  params: {
    location: location
    teamsGroupId: teamsGroupId
    teamsChannelIds: teamsChannelIds
    serverAudience: serverAudience
    serverBaseUrl: backend.outputs.serverBaseUrl
    botBaseUrl: frontend.outputs.botBaseUrl
    botAudience: frontend.outputs.botAudience
    blobStorageAccountName: sharedResources.outputs.storageAccountName
    managedIdentityName: sharedResources.outputs.managedIdentityName
    botIdentityName: frontend.outputs.botIdentityName
    functionAppName: functionApp.outputs.functionAppName
  }
}

// Output
@description('Container registry login server')
output CONTAINER_REGISTRY_LOGIN_SERVER string = sharedResources.outputs.containerRegistryLoginServer
