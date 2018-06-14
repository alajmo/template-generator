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
    echo "tp l" | pv -qL 10
    sleep 2s
    tp l
    echo "\n"

    sleep 2s
    echo "# preview file"
    echo "$ tp p examples/test-2.txt" | pv -qL 30
    sleep 2s
    tp p examples/test-2.txt
    echo "\n"

    sleep 2s
    echo "# generate file"
    echo "$ tp g examples/test-2.txt" | pv -qL 30
    tp generate examples/test-2.txt
    echo "\n"

    # file now available in current directory
    echo "$ ls" | pv -qL 10
    sleep 2s
    ls

    sleep 2s
    printf ""
  '

  # Simulate typing
  asciinema rec -c "$CMD" --max-wait 100 --title tap-report --quiet media/output.json &
  fg %1
}

_generate_gif() {
  # Convert to gif
  docker run --rm -v "$PWD":/data asciinema/asciicast2gif -h 27 media/output.json media/output.gif
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
