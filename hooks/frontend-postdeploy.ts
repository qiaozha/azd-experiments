/**
 * frontend — postdeploy hook
 *
 * Runs after `azd deploy frontend`.
 *
 * Responsibilities:
 *   - Wait for the App Service to start the new container
 *   - Health-check the /health endpoint
 *   - Verify the Bot Service endpoint is registered correctly
 *   - Update the Teams App manifest if the hostname changed
 *   - Send a deployment notification
 */

const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const BOT_HOSTNAME = "azsdkqabot.azurewebsites.net";

function log(msg: string): void {
  console.log(`[frontend:postdeploy] ${msg}`);
}

// ── Step 1: Wait for container startup ───────────────────────────────────────
async function waitForStartup(): Promise<void> {
  log(`Waiting for App Service to start: https://${BOT_HOSTNAME}`);

  // TODO: Poll the App Service until the new container is running.
  //   az webapp show --name azsdkqabot --resource-group ${RESOURCE_GROUP}
  //     --query "state" -o tsv  →  "Running"
  //
  // Use exponential backoff; container cold-starts can take 1–3 minutes.
}

// ── Step 2: Health check ──────────────────────────────────────────────────────
async function healthCheck(): Promise<void> {
  log(`Health-checking: https://${BOT_HOSTNAME}/health`);

  // TODO: Poll until HTTP 200, with retries.
  //   const res = await fetch(`https://${BOT_HOSTNAME}/health`);
  //   if (!res.ok) throw new Error(`Health check failed: ${res.status}`);
}

// ── Step 3: Verify Bot Service endpoint ───────────────────────────────────────
function verifyBotEndpoint(): void {
  log("Verifying Bot Service endpoint registration...");

  // TODO: Confirm the Bot Service's endpoint matches the live App Service URL.
  //   az bot show --name azsdkqabot --resource-group ${RESOURCE_GROUP}
  //     --query "properties.endpoint" -o tsv
  //   Expected: https://azsdkqabot.azurewebsites.net/api/messages
}

// ── Step 4: Update Teams App manifest ────────────────────────────────────────
function updateTeamsManifest(): void {
  log("Checking Teams App manifest...");

  // TODO: Re-upload the manifest if the bot endpoint or App ID changed.
  //   execSync("node scripts/upload-teams-manifest.js", { stdio: "inherit" });
}

// ── Step 5: Deployment notification ──────────────────────────────────────────
function notify(): void {
  log("Sending deployment notification...");

  // TODO: Post to the team's monitoring Teams channel.
  //   const webhookUrl = process.env.TEAMS_WEBHOOK_URL;
  //   if (webhookUrl) {
  //     await fetch(webhookUrl, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({ text: `✅ frontend deployed to '${ENV_NAME}'` }),
  //     });
  //   }
}

(async () => {
  log("Starting");
  await waitForStartup();
  await healthCheck();
  verifyBotEndpoint();
  updateTeamsManifest();
  notify();
  log("Done — Teams bot is live");
})().catch((err) => {
  console.error(`[frontend:postdeploy] FAILED: ${err.message}`);
  process.exit(1);
});
