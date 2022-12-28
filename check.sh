#! /usr/bin/env bash
# ============================================================================ #
#
# Runs subtests in a top-level harness.
#
# ---------------------------------------------------------------------------- #

set -eu;
set -o pipefail

# ---------------------------------------------------------------------------- #

_ec=0;
count=0;

run_test() {
  local name;
  name="$1";
  shift;
  echo "Running Check: $name" >&2;
  if eval "$*" >&2; then
    echo "PASS: $name"
  else
    echo "FAIL: $name"
    _ec=$(( _ec + 1 ));
  fi
  echo '' >&2;
  count=$(( count + 1 ));
}


# ---------------------------------------------------------------------------- #

run_test "Packages Module" ./tests/modules/packages/check.sh;


# ---------------------------------------------------------------------------- #

if [[ "$_ec" -gt 0 ]]; then
  echo "FAILED: $_ec/$count checks.";
else
  echo "PASSED: $count/$count checks.";
fi

exit "$_ec";


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
