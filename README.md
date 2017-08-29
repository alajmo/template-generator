# Template Generator

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

A simple bash script used to generate boilerplates.

## Install

1. Put the file [tp](tp) in an executable path.

Furthermore, if you want bash-autocompletion, follow the below instructions:

1. [Install boilerplates-completion](https://github.com/scop/bash-completion)
2. Source [bash-completion.sh](bash-completion.sh) from `~/.bash_completion`

## Usage

```
template-generator - Template generator CLI

Usage: tp [command] [arguments]

Options:
  -h, --help              Print this help.
  -v,--version            Print script version.

Usage:
  list|ls|l [subdirectory]                List boilerplates
  generate|g boilerplate [destination]    Generate boilerplate
  preview|p boilerplate                   Preview boilerplate
  edit|e boilerplate                      Edit boilerplate in editor
```
