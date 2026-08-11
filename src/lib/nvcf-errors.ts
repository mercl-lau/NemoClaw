// SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: Apache-2.0

/**
 * Detect NVIDIA Cloud Functions "Function not found for account" errors.
 *
 * NVIDIA Build (integrate.api.nvidia.com) returns this when a model is in the
 * public catalog but is not deployed for the caller's account/org.
 */
export function isNvcfFunctionNotFoundForAccount(message: string): boolean {
  return /Function\s+'[^']+':\s*Not found for account/i.test(String(message || ""));
}

/**
 * Build the actionable message shown for an unavailable NVIDIA Cloud
 * Functions model deployment.
 */
export function nvcfFunctionNotFoundMessage(model: string): string {
  return (
    `Model '${model}' not found — it is in the NVIDIA Build catalog but is not deployed ` +
    "for your account. Pick a different model, or check the model card on " +
    "https://build.nvidia.com to see if it requires org-level access."
  );
}
