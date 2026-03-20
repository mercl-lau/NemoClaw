#!/bin/bash
# Case: sandbox registered, status OK, cloud inference + expected model (VDR3 #12).
# Requires: nemoclaw, openshell on PATH.
#
# Env (optional — defaults match test-e2e-cloud-experimental.sh):
#   SANDBOX_NAME or NEMOCLAW_SANDBOX_NAME (default: e2e-cloud-experimental)
#   CLOUD_EXPERIMENTAL_MODEL (legacy: SCENARIO_A_MODEL, NEMOCLAW_CLOUD_EXPERIMENTAL_MODEL, NEMOCLAW_SCENARIO_A_MODEL)
#
# Example:
#   bash test/e2e/e2e-cloud-experimental/cases/01-onboard-completion.sh
#   SANDBOX_NAME=my-box CLOUD_EXPERIMENTAL_MODEL=nvidia/nemotron-3-super-120b-a12b bash ...

set -euo pipefail

SANDBOX_NAME="${SANDBOX_NAME:-${NEMOCLAW_SANDBOX_NAME:-e2e-cloud-experimental}}"
CLOUD_EXPERIMENTAL_MODEL="${CLOUD_EXPERIMENTAL_MODEL:-${SCENARIO_A_MODEL:-${NEMOCLAW_CLOUD_EXPERIMENTAL_MODEL:-${NEMOCLAW_SCENARIO_A_MODEL:-moonshotai/kimi-k2.5}}}}"

die() { printf '%s\n' "01-onboard-completion: FAIL: $*" >&2; exit 1; }

set +e
list_output=$(nemoclaw list 2>&1)
lc=$?
set -e
[ "$lc" -eq 0 ] || die "nemoclaw list failed: ${list_output:0:200}"
echo "$list_output" | grep -Fq -- "$SANDBOX_NAME" \
  || die "nemoclaw list does not contain '${SANDBOX_NAME}'"

set +e
status_output=$(nemoclaw "$SANDBOX_NAME" status 2>&1)
st=$?
set -e
[ "$st" -eq 0 ] || die "nemoclaw ${SANDBOX_NAME} status failed (exit $st): ${status_output:0:200}"

set +e
inf_check=$(openshell inference get 2>&1)
ig=$?
set -e
[ "$ig" -eq 0 ] || die "openshell inference get failed: ${inf_check:0:200}"
echo "$inf_check" | grep -qi "nvidia-nim" \
  || die "openshell inference get missing nvidia-nim provider"
echo "$inf_check" | grep -Fq "$CLOUD_EXPERIMENTAL_MODEL" \
  || die "openshell inference get missing model '${CLOUD_EXPERIMENTAL_MODEL}' (overridden?)"

printf '%s\n' "01-onboard-completion: OK (list, status, inference + model)"
exit 0
