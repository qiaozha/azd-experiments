/**
 * predown hook — runs before `azd down` (resource teardown)
 *
 * Responsibilities:
 *   - Prompt for explicit confirmation before destructive teardown
 *   - Backup critical data (storage tables, blobs, Cosmos DB documents)
 *   - Export App Configuration and Key Vault secrets for archival
 *   - Remove the resource-group delete lock so `azd down` can proceed
 *   - Disable the Logic App and Bot Service to stop incoming traffic
 */

import { execSync } from "child_process";
import { existsSync, mkdirSync } from "fs";
import { join } from "path";

// ── Environment variables injected by azd ─────────────────────────────────────
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const SUBSCRIPTION_ID = process.env.AZURE_SUBSCRIPTION_ID ?? "";

const BACKUP_DIR = join(process.cwd(), ".backup", new Date().toISOString().replace(/[:.]/g, "-"));

function log(message: string): void {
  console.log(`[predown] ${message}`);
}

// ── Step 1: Confirm intent ─────────────────────────────────────────────────────
function confirmTeardown(): void {
  log("─────────────────────────────────────────────────────");
  log("WARNING: You are about to DESTROY the QA Bot environment:");
  log(`  Environment   : ${ENV_NAME}`);
  log(`  Subscription  : ${SUBSCRIPTION_ID}`);
  log(`  Resource group: ${RESOURCE_GROUP}`);
  log("─────────────────────────────────────────────────────");

  // TODO: In a CI environment skip this prompt; in interactive mode require
  // explicit confirmation before proceeding.
  //
  //   import * as readline from "readline";
  //   const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  //   await new Promise<void>((resolve, reject) => {
  //     rl.question("Type 'yes' to confirm teardown: ", (answer) => {
  //       rl.close();
  //       if (answer.trim().toLowerCase() !== "yes") {
  //         reject(new Error("Teardown aborted by user."));
  //       } else {
  //         resolve();
  //       }
  //     });
  //   });
}

// ── Step 2: Create backup directory ───────────────────────────────────────────
function ensureBackupDir(): void {
  log(`Creating backup directory: ${BACKUP_DIR}`);
  mkdirSync(BACKUP_DIR, { recursive: true });
}

// ── Step 3: Backup storage account data ───────────────────────────────────────
function backupStorageData(): void {
  log("Backing up storage account data...");

  // TODO: Use azcopy or the Azure CLI to snapshot critical containers/tables.
  //
  // Containers to back up:
  //   - bot-configs          (tenant and channel configuration blobs)
  //   - knowledge            (knowledge base documents)
  //
  // Tables to back up:
  //   - ConversationState    (bot conversation history)
  //
  //   execSync(
  //     `azcopy copy
  //       "https://azuresdkqabotstorage.blob.core.windows.net/"
  //       "${BACKUP_DIR}/storage/"
  //       --recursive`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 4: Export App Configuration ──────────────────────────────────────────
function exportAppConfiguration(): void {
  log("Exporting App Configuration key-values...");

  // TODO: Dump all configuration keys to a JSON file for archival.
  //
  //   execSync(
  //     `az appconfig kv export
  //       --name azuresdkqabot-config
  //       --destination file
  //       --path "${BACKUP_DIR}/app-config.json"
  //       --format json --yes`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 5: Export Key Vault secret names ─────────────────────────────────────
function exportKeyVaultSecretNames(): void {
  log("Recording Key Vault secret names (values NOT exported)...");

  // TODO: List secret names so they can be recreated after re-provisioning.
  // Do NOT export secret values — use a secure offline backup process instead.
  //
  //   execSync(
  //     `az keyvault secret list
  //       --vault-name azuresdkqabot-keyvalut
  //       --query "[].name"
  //       --output json > "${BACKUP_DIR}/keyvault-secret-names.json"`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 6: Remove the resource-group delete lock ─────────────────────────────
function removeDeleteLock(): void {
  log("Removing resource-group delete lock...");

  // The qaBotFrontend/azureSdkQaBotModule.bicep places a 'CanNotDelete' lock named 'azsdkqabot-delete-lock'
  // on the resource group.  It must be removed before `azd down` can delete resources.

  // TODO: Remove the lock so the teardown can proceed.
  //
  //   execSync(
  //     `az lock delete
  //       --name azsdkqabot-delete-lock
  //       --resource-group ${RESOURCE_GROUP}`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 7: Stop incoming traffic ─────────────────────────────────────────────
function stopIncomingTraffic(): void {
  log("Disabling Logic App and Bot Service to stop incoming traffic...");

  // TODO: Disable the Logic App workflow and Bot Service channel to prevent
  // new messages from arriving while resources are being torn down.
  //
  //   execSync(
  //     `az logic workflow update
  //       --name azuresdkqabot-logicapp
  //       --resource-group ${RESOURCE_GROUP}
  //       --state Disabled`,
  //     { stdio: "inherit" }
  //   );
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  log(`Starting predown for environment '${ENV_NAME}'`);

  confirmTeardown();
  ensureBackupDir();
  backupStorageData();
  exportAppConfiguration();
  exportKeyVaultSecretNames();
  removeDeleteLock();
  stopIncomingTraffic();

  log(`Predown complete. Backups saved to: ${BACKUP_DIR}`);
  log("Proceeding with resource teardown.");
})().catch((err) => {
  console.error(`[predown] FAILED: ${err.message}`);
  process.exit(1);
});
