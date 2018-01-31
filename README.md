# Template Generator

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

A simple bash script used to manage boilerplates.

## Install

1. Put the file [tp](tp) in an executable path.
2. Create a directory named boilerplates in your home folder and fill it with boilerplates.

Furthermore, if you want bash-autocompletion:

3. [Install boilerplates-completion](https://github.com/scop/bash-completion).
4. Source [bash-completion.sh](bash-completion.sh) from `~/.bash_completion`.

## Usage

```

template-generator - Template generator CLI

Usage: tp [command] [arguments] [options]

Options:
  -h, --help              Print this help.
  -v,--version            Print script version.

Usage:
  list|ls|l [subdirectory]                List boilerplates
  generate|g <boilerplate> [destination]  Generate boilerplate
  preview|p <boilerplate>                 Preview boilerplate
  edit|e <boilerplate>                    Edit boilerplate in editor

Looks for boilerplates in the following directories (in the given order):
  Environment variable BOILERPLATES_PATH
  $PWD/.boilerplates/
  $PWD/boilerplates/
  ~/.boilerplates/
  ~/boilerplates/

```
