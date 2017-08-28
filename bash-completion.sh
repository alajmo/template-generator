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

    echo "$path"
}

# File completion
_tp() {
    local cur;
    _get_comp_words_by_ref cur;

    local tmp;
    tmp=$(_get_boilerplates_path)

    local tmp_escaped;
    tmp_escaped=${tmp//\//\\\/}
    cur=$tmp$cur;

    if [ "$1" == "-d" ]; then
        _cd
    else
        _filedir;
    fi;

    local i;
    local _compreply=()
    for i in "${COMPREPLY[@]}"; do
        [ -d "$i" ] && [ "$i" != "$tmp." ] && [ "$i" != "$tmp.." ] && i="$i/"
        if [[ $i != *"/.git/"* ]] && [[ $i != *"./"* ]]; then
            _compreply=("${_compreply[@]}" "$i")
        fi
    done

    COMPREPLY=(${_compreply[@]/$tmp_escaped/})
}

complete -o nospace -F _tp tp

