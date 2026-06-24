/**
 * function-app — predeploy hook
 *
 * Runs before `azd deploy function-app`.
 *
 * Responsibilities:
 *   - Log in to the backend Container Registry (qzqabotcontainer)
 *   - Build the Azure Function Docker image
 *   - Push the image to ACR
 *   - Verify the manifest before the Function App pulls it
 */

import { execSync } from "child_process";
const REGISTRY = process.env.CONTAINER_REGISTRY_LOGIN_SERVER ?? "qzqabotcontainer.azurecr.io";
const IMAGE = `${REGISTRY}/azure-sdk-qa-bot-function:latest`;
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";

function log(msg: string): void {
  console.log(`[function-app:predeploy] ${msg}`);
}

// ── Step 1: ACR login ─────────────────────────────────────────────────────────
function acrLogin(): void {
  log(`Logging in to ACR: ${REGISTRY}`);

  // TODO: Authenticate Docker to the backend registry.
  //   execSync("az acr login --name qzqabotcontainer", { stdio: "inherit" });
}

// ── Step 2: Build image ───────────────────────────────────────────────────────
function buildImage(): void {
  log(`Building image: ${IMAGE}`);

  // TODO: Build the function app container from the source repo.
  //   execSync(
  //     `docker build -t ${IMAGE} ../azure-sdk-qa-bot/function-app`,
  //     { stdio: "inherit" }
  //   );
}

// ── Step 3: Push image ────────────────────────────────────────────────────────
function pushImage(): void {
  log(`Pushing image: ${IMAGE}`);

  // TODO: Push the built image to ACR.
  //   execSync(`docker push ${IMAGE}`, { stdio: "inherit" });
}

// ── Step 4: Verify manifest in ACR ───────────────────────────────────────────
function verifyManifest(): void {
  log("Verifying image manifest in ACR...");

  // TODO: Confirm the tag exists in the registry.
  //   const result = execSync(
  //     "az acr repository show-tags --name qzqabotcontainer --repository azure-sdk-qa-bot-function --output tsv",
  //     { encoding: "utf8" }
  //   );
  //   if (!result.includes("latest")) throw new Error("Image tag 'latest' not found in ACR.");
}

// ── Step 5: Validate required app settings ────────────────────────────────────
function validateAppSettings(): void {
  log("Validating required function app settings...");

  // TODO: Confirm that the Function App's app settings are populated before
  // the new container starts.  Key settings:
  //   - AZURE_CLIENT_ID          (managed identity client ID)
  //   - STORAGE_ACCOUNT_NAME
  //   - APP_CONFIG_ENDPOINT
  //
  //   az functionapp config appsettings list \
  //     --name azuresdkqabot-function \
  //     --resource-group ${RESOURCE_GROUP}
}

(async () => {
  log("Starting");
  acrLogin();
  buildImage();
  pushImage();
  verifyManifest();
  validateAppSettings();
  log("Done");
})().catch((err) => {
  console.error(`[function-app:predeploy] FAILED: ${err.message}`);
  process.exit(1);
});
