#!/bin/bash

set -e

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOILERPLATES_PATH="$TEST_DIR/boilerplates/"
ACTUAL_OUTPUT_DIR="$TEST_DIR/actual-output"
EXPECTED_OUTPUT_DIR="$TEST_DIR/expected-output"

source "$TEST_DIR/assert.sh" # Format: assert <command> [stdout] [stdin]

_pre_test() {
  export BOILERPLATES_PATH="$BOILERPLATES_PATH"
  mkdir -p "$ACTUAL_OUTPUT_DIR"
}
_post_test() {
  export BOILERPLATES_PATH=""
  rm "$ACTUAL_OUTPUT_DIR" -irf
}

_generate_tests() {
  . ./tp generate "g-1.txt" "$ACTUAL_OUTPUT_DIR"

  assert "diff \"$ACTUAL_OUTPUT_DIR/g-1.txt\" \"$EXPECTED_OUTPUT_DIR/g-1.txt\"" "" "Should generate boilerplate"
  assert_end "generate tests"
}

# LIST
# list=$(. ./tp list)
# echo $list
# assert "echo $list" "1"

# assert_end LIST

# export BOILERPLATES_PATH="$PWD/tests/boilerplates"

_main() {
  _pre_test

  _generate_tests

  _post_test

}
_main "${@:-}"
