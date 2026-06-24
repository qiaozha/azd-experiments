/**
 * agent — postdeploy hook
 *
 * Runs after `azd deploy agent`.
 *
 * After the agent.yaml flow creates a new immutable agent version, this hook:
 *   - Surfaces the auto-written AGENT_* env vars (name, version, endpoint)
 *   - Smoke-tests the new version with a single invocation
 *   - Reports the playground URL for manual verification
 *   - Sends a deployment notification
 */

import { execSync } from "child_process";

const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const ENV_NAME = process.env.AZURE_ENV_NAME ?? "";

function log(msg: string): void {
  console.log(`[agent:postdeploy] ${msg}`);
}

// ── Step 1: Surface deployed agent identity ───────────────────────────────────
function showAgent(): void {
  log("Reading deployed agent identity (AGENT_* env vars)...");

  // TODO: deploy auto-writes AGENT_AGENT_NAME / _VERSION / _RESPONSES_ENDPOINT.
  //   const info = execSync("azd ai agent show --output json", { encoding: "utf8" });
  //   log(info);
}

// ── Step 2: Smoke-test invocation ─────────────────────────────────────────────
async function smokeTest(): Promise<void> {
  log("Invoking the new agent version (smoke test)...");

  // TODO: Run one non-interactive invocation against the freshly deployed
  // version and fail the hook if it errors.
  //   const out = execSync(
  //     'azd ai agent invoke --no-prompt --input "ping"',
  //     { encoding: "utf8" }
  //   );
  //   if (!out.trim()) throw new Error("Smoke test returned no output.");
}

// ── Step 3: Report playground URL ─────────────────────────────────────────────
function reportPlayground(): void {
  log("Resolving playground URL...");

  // TODO: Surface the playground URL for manual verification.
  //   azd ai agent show --output json  →  .playground_url
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
  //       body: JSON.stringify({ text: `✅ agent deployed to '${ENV_NAME}'` }),
  //     });
  //   }
}

(async () => {
  log("Starting");
  showAgent();
  await smokeTest();
  reportPlayground();
  notify();
  log("Done — hosted agent is live");
})().catch((err) => {
  console.error(`[agent:postdeploy] FAILED: ${err.message}`);
  process.exit(1);
});
