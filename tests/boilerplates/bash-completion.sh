#!/bin/bash

_dir_completion() {
    COMPREPLY=()
    prefix="${BOILERPLATES_PATH:-$HOME/}"
    prefix="${prefix%/}/"
    autoexpand=${1:-0}

    local IFS=$'\n'
    local items=($(compgen -d $prefix$cur))

    # Remember the value of the first item, to see if it is a directory. If
    # it is a directory, then don't add a space to the completion
    local firstitem=""
    # Use counter, can't use ${#items[@]} as we skip hidden directories
    local i=0

    # If 1 match and it is a directory, add space
    # If More than 1 match and there are directories, don't add space

    for item in ${items[@]}; do
        [[ $item =~ /\.[^/]*$ ]] && continue

        # if there is a unique match, and it is a directory with one entry
        # autocomplete the subentry as well (recursively)
        if [[ ${#items[@]} -eq 1 && $autoexpand -eq 1 ]]; then
            while [[ -d $item ]]; do
                local subitems=($(compgen -d "$item/"))
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

_file_complete() {
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

_{% script_name %}() {
    local commands="{{ commands }}"
    cur=`_get_cword`
    prev=${COMP_WORDS[COMP_CWORD-1]}
    prev2=${COMP_WORDS[COMP_CWORD-2]}
    if [[ $COMP_CWORD -gt 1 ]]; then

        if [[ "$prev" == "{{ command }}" ]]; then
            _file_complete 1
        elif [[ "$prev" == "{{ command }}" ]]; then
            _file_complete 1
        fi

    else
        compopt -o nosort
        COMPREPLY+=($(compgen -W "${commands}" -- ${cur}))
    fi
}

complete -o filenames -o bashdefault -F _{% script_name %} {% script_name %}
