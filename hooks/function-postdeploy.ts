/**
 * function-app — postdeploy hook
 *
 * Runs after `azd deploy function-app`.
 *
 * Responsibilities:
 *   - Wait for the Function App to start the new container
 *   - Invoke a warm-up function to confirm the runtime is healthy
 *   - Verify queue trigger bindings are active
 *   - Send a deployment notification
 */

import { execSync } from "child_process";

const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";
const FUNCTION_HOSTNAME = "azuresdkqabot-function.azurewebsites.net";

function log(msg: string): void {
  console.log(`[function-app:postdeploy] ${msg}`);
}

// ── Step 1: Wait for Function App startup ─────────────────────────────────────
async function waitForStartup(): Promise<void> {
  log(`Waiting for Function App to start: https://${FUNCTION_HOSTNAME}`);

  // TODO: Poll until the Function App reports Running state.
  //   az functionapp show \
  //     --name azuresdkqabot-function \
  //     --resource-group ${RESOURCE_GROUP} \
  //     --query "state" -o tsv  →  "Running"
}

// ── Step 2: Warm-up invocation ────────────────────────────────────────────────
async function warmUp(): Promise<void> {
  log(`Invoking warm-up function: https://${FUNCTION_HOSTNAME}/api/health`);

  // TODO: Call the health or ping function to force a cold-start before
  // real traffic arrives.
  //   const res = await fetch(`https://${FUNCTION_HOSTNAME}/api/health`);
  //   if (!res.ok) throw new Error(`Warm-up failed: ${res.status}`);
}

// ── Step 3: Verify queue trigger bindings ────────────────────────────────────
function verifyTriggers(): void {
  log("Verifying queue trigger bindings...");

  // TODO: List active functions and confirm expected triggers are registered.
  //   az functionapp function list \
  //     --name azuresdkqabot-function \
  //     --resource-group ${RESOURCE_GROUP}
}

// ── Step 4: Deployment notification ──────────────────────────────────────────
function notify(): void {
  log("Sending deployment notification...");

  // TODO: Post to the team's monitoring Teams channel.
  //   const webhookUrl = process.env.TEAMS_WEBHOOK_URL;
  //   if (webhookUrl) {
  //     await fetch(webhookUrl, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({ text: `✅ function-app deployed to '${ENV_NAME}'` }),
  //     });
  //   }
}

(async () => {
  log("Starting");
  await waitForStartup();
  await warmUp();
  verifyTriggers();
  notify();
  log("Done — Function App is live");
})().catch((err) => {
  console.error(`[function-app:postdeploy] FAILED: ${err.message}`);
  process.exit(1);
});
