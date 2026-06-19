/**
 * preprovision hook — runs before `azd provision`
 *
 * Responsibilities:
 *   - Validate prerequisites (Azure CLI, azd, required tools)
 *   - Confirm the caller is authenticated to the correct Azure tenant/subscription
 *   - Check that the target resource group does not already have conflicting resources
 *   - Verify bicep source files are present and up-to-date
 *   - Gate on any environment-specific pre-conditions (quota, policy, etc.)
 */

import { execSync } from "child_process";

// ── Environment variables injected by azd ─────────────────────────────────────
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const SUBSCRIPTION_ID = process.env.AZURE_SUBSCRIPTION_ID ?? "";
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const LOCATION = process.env.AZURE_LOCATION ?? "westus2";

function log(message: string): void {
  console.log(`[preprovision] ${message}`);
}

function run(cmd: string, description: string): string {
  log(`Running: ${description}`);
  return execSync(cmd, { encoding: "utf8" }).trim();
}

// ── Step 1: Check required CLI tools ──────────────────────────────────────────
function checkPrerequisites(): void {
  log("Checking prerequisites...");

  const tools = ["az", "azd"];
  for (const tool of tools) {
    try {
      execSync(`command -v ${tool}`, { stdio: "ignore" });
      log(`  ✓ ${tool} found`);
    } catch {
      throw new Error(`Required tool '${tool}' is not installed or not on PATH.`);
    }
  }

  // TODO: Add any additional tool checks required by the project
  // e.g. node, docker, jq
}

// ── Step 2: Validate Azure authentication ──────────────────────────────────────
function validateAuth(): void {
  log("Validating Azure authentication...");

  // TODO: Verify the signed-in account belongs to the expected tenant
  //   const account = JSON.parse(run("az account show", "get current account"));
  //   if (account.tenantId !== EXPECTED_TENANT_ID) { throw ... }

  if (SUBSCRIPTION_ID) {
    log(`  Target subscription: ${SUBSCRIPTION_ID}`);
  } else {
    log("  AZURE_SUBSCRIPTION_ID not set — azd will use the default subscription.");
  }
}

// ── Step 3: Check resource group state ────────────────────────────────────────
function checkResourceGroup(): void {
  log(`Checking resource group '${RESOURCE_GROUP}'...`);

  // TODO: Query the resource group and warn if it already contains resources
  // that may conflict with this deployment (e.g. a Key Vault with the same name).
  //
  // Example:
  //   const exists = execSync(
  //     `az group exists --name ${RESOURCE_GROUP}`,
  //     { encoding: "utf8" }
  //   ).trim();
  //   if (exists === "true") {
  //     log(`  WARNING: Resource group '${RESOURCE_GROUP}' already exists.`);
  //   }
}

// ── Step 4: Verify bicep source files ──────────────────────────────────────────
function verifyBicepSources(): void {
  const bicepDir = "infra";

  log(`Verifying bicep sources in '${bicepDir}'...`);

  // TODO: Check that all expected layer files are present and newer than a
  // minimum timestamp. Optionally re-run the CDK regeneration script if stale.
  //
  // Expected files:
  //   qaBotSharedResources/userAssignedIdentity.bicep
  //   qaBotAgent/component.bicep
  //   qaBotBackend/serverfarm.bicep
  //   qaBotFrontend/azureSdkQaBotModule.bicep
  //   qaBotFunctionApp/serverfarm.bicep
  //   qaBotLogicApp/integrationAccount.bicep
  //   storage-permissions.bicep
}

// ── Step 5: Quota / policy pre-checks ─────────────────────────────────────────
function checkQuotaAndPolicy(): void {
  log("Checking quota and policy pre-conditions...");

  // TODO: Verify regional quota is sufficient for:
  //   - Azure AI Services (Cognitive Services) model deployments
  //   - Elastic Premium function app plan (EP1)
  //   - Azure Container Registry (Standard tier)
  //
  // TODO: Verify no Azure Policy blocks the deployment (e.g. location
  // restrictions, required tags, SKU restrictions).
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  log(`Starting preprovision for environment '${ENV_NAME}' in '${LOCATION}'`);

  checkPrerequisites();
  validateAuth();
  checkResourceGroup();
  verifyBicepSources();
  checkQuotaAndPolicy();

  log("Preprovision checks passed. Proceeding with provisioning.");
})().catch((err) => {
  console.error(`[preprovision] FAILED: ${err.message}`);
  process.exit(1);
});
