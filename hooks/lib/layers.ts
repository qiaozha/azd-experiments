/**
 * Infra-only layer pipeline for the QA Bot deployment.
 *
 * These layers contain no application code and are therefore managed through
 * azd's postprovision hook rather than as azd services.
 *
 * Each layer can declare an optional `pre` and `post` callback that executes
 * immediately before / after the `az deployment group create` call for that
 * layer.  The callbacks receive a `LayerContext` with resolved runtime values.
 *
 * Partial deployment:
 *   Set the DEPLOY_LAYER env var to run a single layer, e.g.:
 *     DEPLOY_LAYER=agent-platform azd provision
 */

export interface LayerContext {
  resourceGroup: string;
  subscriptionId: string;
  location: string;
}

export interface Layer {
  /** Unique identifier — also used as the az deployment name. */
  name: string;
  /** Path to the .bicep file, relative to the workspace root. */
  bicepFile: string;
  /** Optional hook that runs before `az deployment group create`. */
  pre?: (ctx: LayerContext) => Promise<void>;
  /** Optional hook that runs after `az deployment group create` succeeds. */
  post?: (ctx: LayerContext) => Promise<void>;
}

const BICEP_BASE = "../infra";

export const INFRA_LAYERS: Layer[] = [
  // ── Layer 1: Shared resources ──────────────────────────────────────────────
  // Creates: managed identity, storage account, container registry, Cosmos DB,
  // Key Vault, App Configuration, Search, Log Analytics, action group, and their
  // RBAC role assignments.
  {
    name: "shared-resources",
    bicepFile: `${BICEP_BASE}/qaBotSharedResources/sharedResources.bicep`,
    pre: async (ctx) => {
      // TODO: Check Key Vault name 'azuresdkqabot-keyvalut' is not soft-deleted.
      //   az keyvault list-deleted --query "[?name=='azuresdkqabot-keyvalut']"
      // TODO: Verify managed identity name is available in the subscription.
    },
    post: async (ctx) => {
      // TODO: Capture and store the managed identity principalId for downstream layers.
      //   az identity show --name azuresdkqabot-identity \
      //     --resource-group ${ctx.resourceGroup} --query principalId -o tsv
    },
  },

  // ── Layer 2: Agent platform / AI services ─────────────────────────────────
  // Creates: Application Insights, Azure AI Services account, Foundry project,
  // and model deployments. This is the *platform* the hosted agent runs on; the
  // agent app itself is deployed separately via `azd deploy agent` (agent.yaml).
  {
    name: "agent-platform",
    bicepFile: `${BICEP_BASE}/qaBotAgent/component.bicep`,
    pre: async (ctx) => {
      // TODO: Verify Cognitive Services quota in 'swedencentral' is sufficient.
      //   az cognitiveservices usage list --location swedencentral
      // TODO: Check that no account named 'azuresdkqabot-ai-resource' already exists.
    },
    post: async (ctx) => {
      // TODO: Poll until all model deployments reach 'Running' state.
      //   az cognitiveservices account deployment show \
      //     --name azuresdkqabot-ai-resource \
      //     --deployment-name gpt-4.1 \
      //     --resource-group ${ctx.resourceGroup}
    },
  },

  // ── Layer 3: Backend role assignments ─────────────────────────────────────
  // Grants the backend service-principal RBAC on: ACR, Storage, Key Vault,
  // App Configuration, and Azure Search.
  {
    name: "backend",
    bicepFile: `${BICEP_BASE}/qaBotBackend/serverfarm.bicep`,
    pre: async (ctx) => {
      // TODO: Confirm prerequisite resources (registry, storage, vault, etc.)
      // already exist before applying role assignments.
      //   az acr show --name azuresdkqabotcontainer
      //   az storage account show --name azuresdkqabotstorage
    },
    post: async (ctx) => {
      // TODO: Validate that role assignments were applied correctly.
      //   az role assignment list --assignee <principalId>
    },
  },

  // ── Layer 6: Logic App ────────────────────────────────────────────────────
  // Creates: Integration Account, Teams/Blob/CosmosDB connections, workflow.
  // Note: frontend (Layer 4) and function-app (Layer 5) are azd services and
  // are deployed via `azd deploy`, not this pipeline.
  {
    name: "logic-app",
    bicepFile: `${BICEP_BASE}/qaBotLogicApp/integrationAccount.bicep`,
    pre: async (ctx) => {
      // TODO: Verify the storage account connection string is available
      // for the 'azureblob' managed API connection.
    },
    post: async (ctx) => {
      // TODO: Authorise the Teams and Azure Blob managed API connections.
      // These require an OAuth consent flow that cannot be automated in Bicep.
      //
      //   az rest --method put \
      //     --uri "https://management.azure.com/subscriptions/${ctx.subscriptionId}/resourceGroups/${ctx.resourceGroup}/providers/Microsoft.Web/connections/teams/confirmConsentCode?api-version=2016-06-01" \
      //     --body "{ 'code': '<oauth-code>' }"
      //
      // TODO: Enable the Logic App workflow after connections are authorised.
      //   az logic workflow update \
      //     --name azuresdkqabot-logicapp \
      //     --resource-group ${ctx.resourceGroup} \
      //     --state Enabled
    },
  },
];
