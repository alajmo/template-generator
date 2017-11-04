#!/bin/bash

set -eu
source tests/assert.sh # Format: assert <command> [stdout] [stdin]

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOILERPLATES_PATH="$PWD/tests/boilerplates/"
ACTUAL_OUTPUT="$TEST_DIR/temp"
EXPECTED_OUT="$TEST_DIR/expected-output"

_pre_test() {
  export BOILERPLATES_PATH="$BOILERPLATES_PATH"
  mkdir -p "$ACTUAL_OUTPUT"
}
_post_test() {
  export BOILERPLATES_PATH=""
  rm "$ACTUAL_OUTPUT" -irf
}

_generate_tests() {
  . ./tp generate "g-1.txt" "$OUTPUT"
  # diff
  # assert "echo $list" "1"
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
