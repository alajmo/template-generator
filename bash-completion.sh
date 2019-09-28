#!/bin/bash

# Get boilerplates path
_get_boilerplates_path() {
    local path
    local env_path
    env_path=${BOILERPLATES_PATH:-""}

    if [[ -n "$env_path" ]]; then
        path="$env_path"
    elif [[ -d "$PWD/.boilerplates/" ]]; then
        path="$PWD/.boilerplates/"
    elif [[ -d "$PWD/boilerplates/" ]]; then
        path="$PWD/boilerplates/"
    elif [[ -d "$HOME/.boilerplates/" ]]; then
        path="$HOME/.boilerplates/"
    elif [[ -d "$HOME/boilerplates/" ]]; then
        path="$HOME/boilerplates/"
    fi

    path="$(realpath $path)/"
    echo "$path"
}

## tp [tab] => tp [commands] -> tp n|g|l|p|e
## tp n[tab] => tp new [tab-> $PWD] [tab-> $BOILERPLATE_PATH]
## tp g[tab] => tp generate [tab-> $BOILERPLATES_PATH] [tab-> $PWD]
## tp l[tab] => tp l [tab-> $BOILERPLATES_PATH]
## tp p[tab] => tp preview [tab-> $BOILERPLATES_PATH]
## tp e[tab] => tp edit [tab-> $BOILERPLATES_PATH]

# File completion
_tp() {
    local cur;
    _get_comp_words_by_ref cur;

    local base_path=$(_get_boilerplates_path)
    local base_path_escaped=${base_path//\//\\\/}

    # 4rd argument requires seperate tab-completion.
    local prev
    prev=${COMP_WORDS[COMP_CWORD-2]}
    if [ "$prev" = "g" ] || [ "$prev" = "generate" ]; then
        _filedir
        return 0
    else
        cur=$base_path$cur;
    fi;

    if [ "$1" == "-d" ]; then
        _cd
    else
        _filedir
    fi;

    local i;
    local _compreply=()
    for i in "${COMPREPLY[@]}"; do
        [ -d "$i" ] && [ "$i" != "$base_path." ] && [ "$i" != "$base_path.." ] && i="$i/"
        if [[ $i != *"/.git/"* ]] && [[ $i != *"./"* ]]; then
            _compreply=("${_compreply[@]}" "$i")
        fi
    done

    COMPREPLY=(${_compreply[@]/$base_path_escaped/})
}

complete -o nospace -F _tp tp
