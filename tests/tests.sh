#!/bin/bash

set -e

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOILERPLATES_PATH="$TEST_DIR/boilerplates/"
ACTUAL_OUTPUT_DIR="$TEST_DIR/actual-output"
EXPECTED_OUTPUT_DIR="$TEST_DIR/expected-output"

_cleanup() {
  export BOILERPLATES_PATH=""
  rm "$ACTUAL_OUTPUT_DIR" -irf
}
trap cleanup EXIT

source "$TEST_DIR/assert.sh" # Format: assert <command> [stdout] [stdin]

_pre_test() {
  export BOILERPLATES_PATH="$BOILERPLATES_PATH"
  mkdir -p "$ACTUAL_OUTPUT_DIR"
}

_generate_tests() {
  source ./tp generate "g-1.txt" "$ACTUAL_OUTPUT_DIR"
  assert "diff $ACTUAL_OUTPUT_DIR/g-1.txt $EXPECTED_OUTPUT_DIR/g-1.txt" "" "Should generate boilerplate"

  source ./tp generate "vs-1.txt" "$ACTUAL_OUTPUT_DIR"
  assert "diff $ACTUAL_OUTPUT_DIR/vs-1.txt $EXPECTED_OUTPUT_DIR/vs-1.txt" "" "Should generate variable substituted boilerplate"

  assert_end "generate tests"
}

_main() {
  _pre_test

  _generate_tests

  _cleanup
}
_main "${@:-}"
