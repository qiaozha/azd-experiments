/**
 * postprovision hook — runs after `azd provision`
 *
 * Drives the infra-only layer pipeline (shared-resources → agent → backend →
 * logic-app) via hooks/lib/deploy-layer.ts.  The application services
 * (frontend, function-app) are azd services and are handled by `azd deploy`
 * with their own per-service hooks.
 *
 * Partial deployment:
 *   DEPLOY_LAYER=agent azd provision   — deploys only the agent layer
 */

import { INFRA_LAYERS } from "./lib/layers.js";
import { runLayerPipeline } from "./lib/deploy-layer.js";

// ── Environment variables injected by azd ─────────────────────────────────────
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const SUBSCRIPTION_ID = process.env.AZURE_SUBSCRIPTION_ID ?? "";
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const LOCATION = process.env.AZURE_LOCATION ?? "westus2";

function log(message: string): void {
  console.log(`[postprovision] ${message}`);
}

// ── Step 1: Run the infra layer pipeline ──────────────────────────────────────
async function runInfraLayers(): Promise<void> {
  log("Starting infra layer pipeline...");

  await runLayerPipeline(INFRA_LAYERS, {
    resourceGroup: RESOURCE_GROUP,
    subscriptionId: SUBSCRIPTION_ID,
    location: LOCATION,
  });
}

// ── Step 2: Seed Key Vault secrets ────────────────────────────────────────────
function seedKeyVaultSecrets(): void {
  log("Seeding Key Vault secrets...");

  // TODO: Populate required secrets in 'azuresdkqabot-keyvalut'.
  // These secrets are consumed by the bot server and function app at runtime.
  //
  // Example:
  //   az keyvault secret set
  //     --vault-name azuresdkqabot-keyvalut
  //     --name GitHubAppPrivateKey
  //     --value "<base64-encoded PEM>"
  //
  // Secret inventory (add entries as needed):
  //   - GitHubAppPrivateKey      : GitHub App private key for issue integration
  //   - TeamsWebhookUrl          : Incoming webhook URL for alerts
  //   - CosmosDbConnectionString : CosmosDB connection string for Logic App
}

// ── Step 3: Update App Configuration store ────────────────────────────────────
function updateAppConfiguration(): void {
  log("Updating App Configuration store...");

  // TODO: Write runtime configuration keys to 'azuresdkqabot-config'.
  // These are read by the backend service principal at startup.
  //
  // Example:
  //   az appconfig kv set
  //     --name azuresdkqabot-config
  //     --key BotSettings:TenantId
  //     --value "$AZURE_TENANT_ID"
  //
  // Keys to populate:
  //   - BotSettings:TenantId
  //   - BotSettings:ClientId       (from the managed identity)
  //   - AiServices:Endpoint        (from the Cognitive Services account)
  //   - Search:Endpoint            (from the Search service)
}

// ── Step 4: Print deployment summary ──────────────────────────────────────────
function printSummary(): void {
  log("─────────────────────────────────────────────────────");
  log(`Environment : ${ENV_NAME}`);
  log(`Subscription: ${SUBSCRIPTION_ID}`);
  log(`Resource grp: ${RESOURCE_GROUP}`);
  log("");
  log("Key resource names:");
  log("  Bot front-end   : https://azsdkqabot.azurewebsites.net");
  log("  Function App    : https://azuresdkqabot-function.azurewebsites.net");
  log("  AI Services     : azuresdkqabot-ai-resource.cognitiveservices.azure.com");
  log("  Key Vault       : azuresdkqabot-keyvalut.vault.azure.net");
  log("");
  log("Next step: run `azd deploy` to push the frontend and function-app images.");
  log("─────────────────────────────────────────────────────");
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  log(`Starting postprovision for environment '${ENV_NAME}'`);

  await runInfraLayers();
  seedKeyVaultSecrets();
  updateAppConfiguration();
  printSummary();

  log("Postprovision complete.");
})().catch((err) => {
  console.error(`[postprovision] FAILED: ${err.message}`);
  process.exit(1);
});
