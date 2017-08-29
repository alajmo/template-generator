#!/bin/bash

set -e

. assert.sh # Format: assert <command> [stdout] [stdin]

# LIST
list=$(. ./tp.sh list)
assert "echo $list" "1"

assert_end LIST
