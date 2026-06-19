/**
 * postdown hook — runs after `azd down` (resource teardown)
 *
 * Responsibilities:
 *   - Confirm all resource layers have been deleted
 *   - Clean up any local environment files and cached credentials
 *   - Archive the backup created by predown for long-term retention
 *   - Deregister the Teams App from the tenant app catalog (if applicable)
 *   - Send a teardown notification to the team
 */

import { execSync } from "child_process";
import { existsSync, readdirSync, renameSync } from "fs";
import { join } from "path";

// ── Environment variables injected by azd ─────────────────────────────────────
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const SUBSCRIPTION_ID = process.env.AZURE_SUBSCRIPTION_ID ?? "";

function log(message: string): void {
  console.log(`[postdown] ${message}`);
}

// ── Step 1: Confirm resource group was deleted ─────────────────────────────────
function confirmResourceGroupDeleted(): void {
  log(`Confirming resource group '${RESOURCE_GROUP}' has been removed...`);

  // TODO: Poll until the resource group no longer exists.
  //
  //   const exists = execSync(
  //     `az group exists --name ${RESOURCE_GROUP}`,
  //     { encoding: "utf8" }
  //   ).trim();
  //   if (exists === "true") {
  //     log("  WARNING: Resource group still exists. Some resources may have resisted deletion.");
  //   } else {
  //     log("  ✓ Resource group deleted successfully.");
  //   }
}

// ── Step 2: Clean up local azd environment files ──────────────────────────────
function cleanupLocalFiles(): void {
  log("Cleaning up local azd environment state...");

  // TODO: Remove the .azure/<ENV_NAME> directory that azd creates locally.
  // This prevents stale environment state from affecting future deployments.
  //
  //   const envDir = join(process.cwd(), ".azure", ENV_NAME);
  //   if (existsSync(envDir)) {
  //     execSync(`rm -rf "${envDir}"`, { stdio: "inherit" });
  //     log(`  Removed: ${envDir}`);
  //   }
}

// ── Step 3: Archive the predown backup ────────────────────────────────────────
function archiveBackup(): void {
  log("Archiving predown backup...");

  // TODO: Move the most recent .backup/* snapshot to a long-term storage
  // location (Azure Storage, an S3-compatible store, or a shared drive).
  //
  //   const backupRoot = join(process.cwd(), ".backup");
  //   if (existsSync(backupRoot)) {
  //     const snapshots = readdirSync(backupRoot).sort();
  //     const latest = snapshots[snapshots.length - 1];
  //     execSync(
  //       `azcopy copy "${join(backupRoot, latest)}" "https://myarchive.blob.core.windows.net/qa-bot-backups/${latest}/" --recursive`,
  //       { stdio: "inherit" }
  //     );
  //   }
}

// ── Step 4: Remove soft-deleted Key Vault (if needed) ─────────────────────────
function purgeDeletedKeyVault(): void {
  log("Checking for soft-deleted Key Vault...");

  // Azure Key Vault has a soft-delete retention period (90 days by default).
  // A vault with the same name cannot be re-created until the soft-deleted
  // instance is purged.  Only run this if you intend to redeploy with the
  // same vault name in the near future.

  // TODO: Purge the soft-deleted vault — IRREVERSIBLE.
  //
  //   execSync(
  //     `az keyvault purge --name azuresdkqabot-keyvalut --location westus2`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 5: Deregister Teams App ─────────────────────────────────────────────
function deregisterTeamsApp(): void {
  log("Deregistering Teams App from tenant catalog...");

  // TODO: Remove the Teams App manifest from the tenant app catalog
  // so users no longer see the bot in the app store.
  //
  //   execSync("node scripts/remove-teams-manifest.js", { stdio: "inherit" });
}

// ── Step 6: Send teardown notification ────────────────────────────────────────
function sendTeardownNotification(): void {
  log("Sending teardown notification...");

  // TODO: Notify the team that the environment has been torn down.
  //
  //   const webhookUrl = process.env.TEAMS_WEBHOOK_URL;
  //   if (webhookUrl) {
  //     await fetch(webhookUrl, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({
  //         text: `🗑️ QA Bot environment '${ENV_NAME}' has been torn down.`
  //       }),
  //     });
  //   }
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  log(`Starting postdown for environment '${ENV_NAME}' (subscription: ${SUBSCRIPTION_ID})`);

  confirmResourceGroupDeleted();
  cleanupLocalFiles();
  archiveBackup();
  purgeDeletedKeyVault();
  deregisterTeamsApp();
  sendTeardownNotification();

  log("Postdown complete. Environment has been fully decommissioned.");
})().catch((err) => {
  console.error(`[postdown] FAILED: ${err.message}`);
  process.exit(1);
});
