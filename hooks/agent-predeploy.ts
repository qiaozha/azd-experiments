/**
 * agent — predeploy hook. Runs before `azd deploy agent`.
 *
 * azd builds + pushes the container and owns the image tag, so this hook only
 * wires env vars and validates agent.yaml. It does NOT build or push.
 */

import { execSync } from "child_process";

const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";
const AGENT_DIR = "../azure-sdk-tools/tools/sdk-ai-bots/azure-sdk-qa-bot-agent/agents/chat_agent";

function log(msg: string): void {
  console.log(`[agent:predeploy] ${msg}`);
}

function resolveProject(): void {
  log("Resolving Foundry project endpoint/id from the agent-platform layer...");

  // TODO: publish AZURE_AI_PROJECT_ENDPOINT / AZURE_AI_PROJECT_ID via `azd env set`.
}

function setModelDeployment(): void {
  log("Pinning AZURE_AI_MODEL_DEPLOYMENT_NAME...");

  // TODO: `azd env set AZURE_AI_MODEL_DEPLOYMENT_NAME gpt-4.1` (must match agent-platform layer).
}

function validateAgentYaml(): void {
  log(`Validating ${AGENT_DIR}/agent.yaml ...`);

  // TODO: validate kind/name/protocols/resources, no image: field.
  // Build context must be the parent dir (../azure-sdk-qa-bot-agent), not the agent dir.
}

(async () => {
  log("Starting");
  resolveProject();
  setModelDeployment();
  validateAgentYaml();
  log("Done");
})().catch((err) => {
  console.error(`[agent:predeploy] FAILED: ${err.message}`);
  process.exit(1);
});
