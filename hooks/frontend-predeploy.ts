/**
 * frontend — predeploy hook
 *
 * Runs before `azd deploy frontend`.
 *
 * Responsibilities:
 *   - Log in to the frontend Container Registry (azsdkqabot)
 *   - Build the Teams bot Docker image
 *   - Push the image to ACR
 *   - Verify the manifest is accessible before the App Service pulls it
 */

import { execSync } from "child_process";

const REGISTRY = "azsdkqabot.azurecr.io";
const IMAGE = `${REGISTRY}/azure-sdk-qa-bot:latest`;
const RESOURCE_GROUP = process.env.AZURE_RESOURCE_GROUP ?? "azure-sdk-qa-bot";

function log(msg: string): void {
  console.log(`[frontend:predeploy] ${msg}`);
}

// ── Step 1: ACR login ─────────────────────────────────────────────────────────
function acrLogin(): void {
  log(`Logging in to ACR: ${REGISTRY}`);

  // TODO: Authenticate Docker to the frontend registry.
  //   execSync("az acr login --name azsdkqabot", { stdio: "inherit" });
}

// ── Step 2: Build image ───────────────────────────────────────────────────────
function buildImage(): void {
  log(`Building image: ${IMAGE}`);

  // TODO: Build the Teams bot container from the source repo.
  //   execSync(
  //     `docker build -t ${IMAGE} ../azure-sdk-qa-bot/frontend`,
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

  // TODO: Confirm the tag exists and is pullable before the App Service rolls
  // to the new image.
  //   const result = execSync(
  //     "az acr repository show-tags --name azsdkqabot --repository azure-sdk-qa-bot --output tsv",
  //     { encoding: "utf8" }
  //   );
  //   if (!result.includes("latest")) throw new Error("Image tag 'latest' not found in ACR.");
}

(async () => {
  log("Starting");
  acrLogin();
  buildImage();
  pushImage();
  verifyManifest();
  log("Done");
})().catch((err) => {
  console.error(`[frontend:predeploy] FAILED: ${err.message}`);
  process.exit(1);
});
