// Main azd orchestration template for the QA Bot chatbot service.
// Each Bicep file represents a deployment layer generated from
// packages/demo/qa-bot in the azure-cdk repo. This template deploys
// them in dependency order as Bicep modules.

targetScope = 'subscription'

@description('Azure region for all resources.')
param location string = 'westus2'

@description('Name of the resource group to deploy into.')
param resourceGroupName string = 'azure-sdk-qa-bot'

// ── Resource Group ─────────────────────────────────────────────────────────────
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// ── Layer 1: Shared resources ──────────────────────────────────────────────────
// Creates: managed identity, Log Analytics workspace, action group, Key Vault.
// Everything else depends on these foundational resources.
module sharedResources '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotSharedResources/userAssignedIdentity.bicep' = {
  name: 'shared-resources'
  scope: rg
}

// ── Layer 2: Agent / AI services ───────────────────────────────────────────────
// Creates: Application Insights (agent), Azure AI Services account,
// GPT-4.1 / GPT-4.1-mini / GPT-5.4 / o4-mini / text-embedding model deployments,
// and metric alerts wired to the shared action group.
module agent '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotAgent/component.bicep' = {
  name: 'agent'
  scope: rg
  dependsOn: [sharedResources]
}

// ── Layer 3: Backend role assignments ──────────────────────────────────────────
// Grants the backend service-principal RBAC roles on: Container Registry,
// Storage Account, Key Vault, App Configuration, and Azure Search.
module backend '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotBackend/serverfarm.bicep' = {
  name: 'backend'
  scope: rg
  dependsOn: [sharedResources, agent]
}

// ── Layer 4: Frontend (Teams Bot) ──────────────────────────────────────────────
// Creates: managed identity, Log Analytics workspace, Application Insights,
// Container Registry, App Service Plan, App Service (bot container),
// Bot Service + Teams channel, web test, metric alerts, delete lock,
// and invokes the storage-permissions sub-module for cross-RG role assignments.
module frontend '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotFrontend/userAssignedIdentity.bicep' = {
  name: 'frontend'
  scope: rg
  dependsOn: [sharedResources, backend]
}

// ── Layer 5: Function App ───────────────────────────────────────────────────────
// Creates: Elastic Premium App Service Plan, Application Insights,
// and Function App site running the bot-function Docker container.
module functionApp '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotFunctionApp/serverfarm.bicep' = {
  name: 'function-app'
  scope: rg
  dependsOn: [sharedResources, backend]
}

// ── Layer 6: Logic App ─────────────────────────────────────────────────────────
// Creates: Integration Account, managed API connections (Teams, Azure Blob,
// Cosmos DB), and the Logic App workflow that wires them together.
module logicApp '../../azure-cdk/packages/demo/qa-bot/output/bicep/qaBotLogicApp/integrationAccount.bicep' = {
  name: 'logic-app'
  scope: rg
  dependsOn: [sharedResources, frontend]
}
