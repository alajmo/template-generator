#!/bin/bash

set -eum
IFS=$'\n\t'

_init() {
  rm media/* -rf
  mkdir media/png
}

_simulate_report() {
  local CMD='
    clear
    export PS1="-> "

    export BOILERPLATES_PATH=$PWD/tests/boilerplates/

    sleep 2s
    echo "# list all boilerplats"
    sleep 1s
    echo "$ tp list" | pv -qL 10
    sleep 2s
    tp list
    echo "\n"

    sleep 2s
    echo "# preview file"
    echo "$ tp preview examples/test-2.txt" | pv -qL 30
    sleep 2s
    tp preview examples/test-2.txt
    echo "\n"

    sleep 2s
    echo "# generate file"
    echo "$ tp generate examples/test-2.txt" | pv -qL 30
    tp generate examples/test-2.txt
    echo "\n"

    # file now available in current directory
    echo "$ ls -A" | pv -qL 10
    sleep 1s
    ls -A | grep "test-2.txt\|$" --color

    sleep 4s
    echo " "
  '

  # Simulate typing
  asciinema rec -c "$CMD" --max-wait 100 --title tap-report --quiet media/output.json &
  fg %1
}

_generate_gif() {
  # Convert to gif
  docker run --rm -v "$PWD":/data asciinema/asciicast2gif -h 30 media/output.json media/output.gif
}

_generate_png() {
  # Generate png's from gif
  convert -verbose -coalesce media/output.gif media/png/output.png

  # Remove all png's except last sequence
  find media/png/*.png | sort -n -t "-" -k 2 | head -n -1 | xargs rm

  mv media/png/*.png media/output.png
  rm media/png -r
}

_cleanup() {
  rm test-2.txt
}

_main() {
  _init
  _simulate_report
  _generate_gif
  # generate_png
  _cleanup
}

_main
