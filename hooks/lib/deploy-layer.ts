/**
 * deployLayer — executes a single infra layer with its pre/post callbacks.
 *
 * Wraps `az deployment group create` and surfaces any CLI errors as thrown
 * exceptions so the caller (postprovision.ts) can abort the pipeline.
 */

import { execSync } from "child_process";
import { existsSync } from "fs";
import { resolve } from "path";
import type { Layer, LayerContext } from "./layers.js";

function log(layer: string, message: string): void {
  console.log(`[${layer}] ${message}`);
}

/**
 * Runs the full lifecycle for one layer:
 *   1. Resolve and validate the bicep file path
 *   2. Call layer.pre()
 *   3. az deployment group create
 *   4. Call layer.post()
 */
export async function deployLayer(layer: Layer, ctx: LayerContext): Promise<void> {
  const bicepPath = resolve(process.cwd(), layer.bicepFile);

  // ── Validate bicep file exists ───────────────────────────────────────────
  if (!existsSync(bicepPath)) {
    throw new Error(
      `Bicep file not found for layer '${layer.name}': ${bicepPath}`
    );
  }

  // ── Pre-deploy callback ─────────────────────────────────────────────────
  log(layer.name, "pre-deploy");
  await layer.pre?.(ctx);

  // ── az deployment group create ──────────────────────────────────────────
  log(layer.name, `deploying → ${bicepPath}`);

  const cmd = [
    "az deployment group create",
    `--resource-group "${ctx.resourceGroup}"`,
    `--template-file "${bicepPath}"`,
    `--name "${layer.name}"`,
    "--no-prompt",
  ].join(" \\\n  ");

  execSync(cmd, { stdio: "inherit" });
  log(layer.name, "deployment succeeded");

  // ── Post-deploy callback ────────────────────────────────────────────────
  log(layer.name, "post-deploy");
  await layer.post?.(ctx);
}

/**
 * Runs the full infra layer pipeline in order.
 * If DEPLOY_LAYER env var is set, only that layer is deployed.
 *
 * @param layers  Ordered list of layers (from layers.ts)
 * @param ctx     Runtime context (resource group, subscription, location)
 */
export async function runLayerPipeline(
  layers: Layer[],
  ctx: LayerContext
): Promise<void> {
  const targetLayer = process.env.DEPLOY_LAYER?.trim();

  const toRun = targetLayer
    ? layers.filter((l) => l.name === targetLayer)
    : layers;

  if (targetLayer && toRun.length === 0) {
    throw new Error(
      `DEPLOY_LAYER='${targetLayer}' does not match any layer. ` +
        `Valid names: ${layers.map((l) => l.name).join(", ")}`
    );
  }

  if (targetLayer) {
    console.log(`[pipeline] Partial deployment — running layer: ${targetLayer}`);
  } else {
    console.log(`[pipeline] Full deployment — running ${toRun.length} layers`);
  }

  for (const layer of toRun) {
    await deployLayer(layer, ctx);
  }

  console.log("[pipeline] All layers complete.");
}
