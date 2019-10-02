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

_pass_complete_entries () {
    COMPREPLY=()
    prefix="${BOILERPLATES_PATH:-$HOME/}"
    prefix="${prefix%/}/"
    autoexpand=${1:-0}

    local IFS=$'\n'
    local items=($(compgen -f $prefix$cur))

    # Remember the value of the first item, to see if it is a directory. If
    # it is a directory, then don't add a space to the completion
    local firstitem=""
    # Use counter, can't use ${#items[@]} as we skip hidden directories
    local i=0

    for item in ${items[@]}; do
            [[ $item =~ /\.[^/]*$ ]] && continue

            # if there is a unique match, and it is a directory with one entry
            # autocomplete the subentry as well (recursively)
            if [[ ${#items[@]} -eq 1 && $autoexpand -eq 1 ]]; then
                    while [[ -d $item ]]; do
                            local subitems=($(compgen -f "$item/"))
                            local filtereditems=( )
                            for item2 in "${subitems[@]}"; do
                                    [[ $item2 =~ /\.[^/]*$ ]] && continue
                                    filtereditems+=( "$item2" )
                            done
                            if [[ ${#filtereditems[@]} -eq 1 ]]; then
                                    item="${filtereditems[0]}"
                            else
                                    break
                            fi
                    done
            fi

            # append / to directories
            [[ -d $item ]] && item="$item/"

            COMPREPLY+=("${item#$prefix}")
            if [[ $i -eq 0 ]]; then
                    firstitem=$item
            fi
            let i+=1
    done

    # The only time we want to add a space to the end is if there is only
    # one match, and it is not a directory
    if [[ $i -gt 1 || ( $i -eq 1 && -d $firstitem ) ]]; then
            compopt -o nospace
    fi
}

# File completion
_tp() {
    COMPREPLY=()
    COMPREPLY+=($(compgen -W "list new generate edit create preview" "${COMP_WORDS[1]}"))

    cur=`_get_cword`
    prev=${COMP_WORDS[COMP_CWORD-1]}
    # _expand || return 0

    # echo "$cur" > lala
    # echo "$prev" >> lala

    # ${COMP_WORDS[COMP_CWORD-1]} == "generate"
    # if [[ $cur == "generate" ]]; then
    #     # If previous is generate, complete cwd path
    #     # Add space
    #     COMPREPLY=()
    #     _=_
    # [[ "$cur" == "generate" ]] ||
    if [[ ${COMP_WORDS[COMP_CWORD-1]} == "generate" ]]; then
        # TODO: Don't expand on last entry
        _pass_complete_entries
    elif [[ ${COMP_WORDS[COMP_CWORD-2]} == "generate" ]]; then
        # If previous previous is generate, complete boilerplate path
        # also remove COMPGEN entries such as generate/list, etc.
        _filedir
        COMPREPLY=()
        COMPREPLY+=( $(compgen -o default -- "${COMP_WORDS[COMP_CWORD]}") )
        _=_
    else
        # _filedir
        # COMPREPLY+=( $(compgen -o filenames -- "${COMP_WORDS[COMP_CWORD]}") )
        # COMPREPLY=()
        _=_
    fi

    return 0
    # COMPREPLY+=("list")
    # COMPREPLY+=("new")
    # COMPREPLY+=("edit")
    # COMPREPLY+=("preview")
    # COMPREPLY+=("generate")
}

complete -o filenames -o bashdefault -F _tp tp
