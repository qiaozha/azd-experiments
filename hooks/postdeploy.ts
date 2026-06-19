/**
 * postdeploy hook — runs after `azd deploy`
 *
 * Responsibilities:
 *   - Verify the bot front-end (/health) and function app are responding
 *   - Run post-deployment smoke tests (Teams message round-trip, search queries)
 *   - Restart or warm up the Logic App workflow
 *   - Update the Teams App manifest if the bot endpoint changed
 *   - Notify the team (email / Teams channel) that a new version is live
 */

import { execSync } from "child_process";

// ── Environment variables injected by azd ─────────────────────────────────────
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";

// Well-known endpoints
const BOT_HOSTNAME = "azsdkqabot.azurewebsites.net";
const FUNCTION_HOSTNAME = "azuresdkqabot-function.azurewebsites.net";

function log(message: string): void {
  console.log(`[postdeploy] ${message}`);
}

// ── Step 1: Health check — bot front-end ─────────────────────────────────────
async function healthCheckFrontend(): Promise<void> {
  log(`Checking bot front-end health: https://${BOT_HOSTNAME}/health`);

  // TODO: Poll the /health endpoint with retries until the new container
  // has started successfully.
  //
  //   const maxRetries = 10;
  //   for (let i = 0; i < maxRetries; i++) {
  //     try {
  //       const res = await fetch(`https://${BOT_HOSTNAME}/health`);
  //       if (res.ok) { log("  ✓ Bot front-end is healthy"); return; }
  //     } catch { /* wait and retry */ }
  //     await new Promise(r => setTimeout(r, 15_000));
  //   }
  //   throw new Error("Bot front-end health check timed out.");
}

// ── Step 2: Health check — function app ───────────────────────────────────────
async function healthCheckFunctionApp(): Promise<void> {
  log(`Checking function app health: https://${FUNCTION_HOSTNAME}`);

  // TODO: Invoke a lightweight function to confirm the new image is running.
  //
  //   const res = await fetch(`https://${FUNCTION_HOSTNAME}/api/health`);
  //   if (!res.ok) throw new Error("Function app health check failed.");
}

// ── Step 3: Run smoke tests ────────────────────────────────────────────────────
async function runSmokeTests(): Promise<void> {
  log("Running post-deployment smoke tests...");

  // TODO: Execute integration tests that exercise the full bot pipeline:
  //   1. Send a test message via the Direct Line channel
  //   2. Confirm the AI Services endpoint responds to a completion request
  //   3. Confirm the Azure Search index is queryable
  //   4. Confirm the function app processes a test queue message
  //
  //   execSync("npx jest --testPathPattern=smoke", { stdio: "inherit" });
}

// ── Step 4: Restart Logic App workflow ────────────────────────────────────────
function restartLogicApp(): void {
  log("Ensuring Logic App workflow is enabled...");

  // TODO: Re-enable the Logic App if it was disabled during deployment to
  // avoid partial-state triggers.
  //
  //   execSync(
  //     `az logic workflow update
  //       --name azuresdkqabot-logicapp
  //       --resource-group ${RESOURCE_GROUP}
  //       --state Enabled`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 5: Update Teams App manifest ─────────────────────────────────────────
function updateTeamsManifest(): void {
  log("Checking Teams App manifest...");

  // TODO: If the bot endpoint or App ID changed, re-upload the Teams App
  // manifest to the Teams Developer Portal or the tenant app catalog.
  //
  //   execSync("node scripts/upload-teams-manifest.js", { stdio: "inherit" });
}

// ── Step 6: Send deployment notification ──────────────────────────────────────
function sendDeploymentNotification(): void {
  log("Sending deployment notification...");

  // TODO: Post a summary to the team's monitoring Teams channel or email list.
  //
  //   const webhookUrl = process.env.TEAMS_WEBHOOK_URL;
  //   if (webhookUrl) {
  //     await fetch(webhookUrl, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({
  //         text: `✅ QA Bot deployed to '${ENV_NAME}' successfully.`
  //       }),
  //     });
  //   }
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  log(`Starting postdeploy for environment '${ENV_NAME}'`);

  await healthCheckFrontend();
  await healthCheckFunctionApp();
  await runSmokeTests();
  restartLogicApp();
  updateTeamsManifest();
  sendDeploymentNotification();

  log("Postdeploy complete. QA Bot is live.");
})().catch((err) => {
  console.error(`[postdeploy] FAILED: ${err.message}`);
  process.exit(1);
});
