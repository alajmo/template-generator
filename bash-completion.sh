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
## tp l[tab] => tp list [tab-> $BOILERPLATES_PATH]
## tp n[tab] => tp new [tab-> $PWD] [tab-> $BOILERPLATE_PATH]
## tp e[tab] => tp edit [tab-> $BOILERPLATES_PATH]
## tp p[tab] => tp preview [tab-> $BOILERPLATES_PATH]
## tp g[tab] => tp generate [tab-> $BOILERPLATES_PATH] [tab-> $PWD]

# File completion
_tp() {
    COMPREPLY=()
    COMPREPLY+=($(compgen -W "list" "${COMP_WORDS[1]}"))
    COMPREPLY+=($(compgen -W "new" "${COMP_WORDS[1]}"))

    cur=`_get_cword`
    prev=${COMP_WORDS[COMP_CWORD-1]}
    _expand || return 0

    # echo "$cur" > lala
    # echo "$prev" >> lala

    # ${COMP_WORDS[COMP_CWORD-1]}
    if [[ $cur == "list" ]]; then
        _filedir
    fi

    # _filedir
    # COMPREPLY+=("list")
    # COMPREPLY+=("new")
    # COMPREPLY+=("edit")
    # COMPREPLY+=("preview")
    # COMPREPLY+=("generate")

    return

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
