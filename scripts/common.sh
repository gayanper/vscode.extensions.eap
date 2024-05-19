#!/bin/bash
function read_repos {
    read_repos_val=()
    fixlines $1
    local file_path=$1
    while IFS='=' read -r key value || [ -n "$key" ]
    do
        if [[ $key != \#* ]]; then
            read_repos_val+=("$key:$value")
        fi
    done < "$file_path"
}

function read_entries {
    entries=()
    fixlines $1
    local file_path=$1
    while IFS='=' read -r key value || [ -n "$key" ]
    do
        if [[ $key != \#* ]]; then
            entries+=("$key:$value")
        fi
    done < "$file_path"
    echo "${entries[@]}"
}

function read_refs {
    read_refs_val=()
    fixlines $1
    local file_path=$1
    while IFS= read -r ref || [ -n "$ref" ]
    do
        if [[ $ref != \#* ]]; then
            read_refs_val+=("$ref")
        fi
    done < "$file_path"
}

function fixlines {
    mv $1 $1.src && \
    tr -d '\r' < $1.src > $1 && \
    rm $1.src
}

function read_key {
    echo ${1%%:*}
}

function read_value {
    echo ${1#*:}
}

function cherry_pick_pr {
    echo "Applying PR # : $1"

    branch_name=$(compute_branch_name $1)
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

    gh pr checkout $1 -b $branch_name && git switch $main_branch

    if [[ $? -ne 0 ]]; then
        echo "::error:: Fail to checkout PR: $1 , ignoring."
    fi

    git merge $branch_name --no-edit
    
    if [[ $? -ne 0 ]]; then
        # try to reset test code and see if the conflicts go away
        for f in $(git status --porcelain | grep '/tests/' | sed 's/^D \+//')
        do
            git reset HEAD "$f"
            git checkout HEAD -- "$f"
        done

        if [[ -z $(git ls-files --unmerged) ]]; then
            git commit --no-edit
            echo "::debug:: Recovered from a conflict while applying: $1."
        else    
            git reset --hard
            # $2 ignore merge conflicts
            if [ "$2" == "true" ]; then
                echo "::warning:: Detected a conflict while applying: $1, ignoring patch."
            else
                echo "::error:: Detected a conflict while applying: $1, ignoring patch."
            fi
        fi
    fi       
}

function compute_branch_name {
    if [[ "$1" == https:* ]]; then
        #read the last patch segment of the url
        branch_name=b${1##*/}
    else 
        branch_name=b$1
    fi
    echo "$branch_name"
}

function apply_git_patches_by_regex {
    echo "Apply git patch files for repo $2"
    patch_pattern=$1"/patches/"$2".*.patch"

    for p in $(ls $patch_pattern 2>/dev/null)
    do
        echo "Applying patch file $p"
        git apply --apply $p && git add . && git commit -m "Patch $p"
        if [[ $? -ne 0 ]]; then
            echo "::error:: Fail to apply patch: $p"
            exit 100
        fi        
    done
}

function patch_target_file {
    file_path=$1
    placeholder=$2
    p2_path=$3


    if [[ -f $file_path ]]; then
        echo "Patching file $file_path"
        sed -i "s/$placeholder/$p2_path/" $file_path
    else
        echo "File $file_path not found, terminating."
        exit 100
    fi
}

# Start VSCodium 
# from https://github.com/VSCodium/vscodium/blob/master/prepare_vscode.sh
function setpath() {
  { set +x; } 2>/dev/null
  echo "$( cat "${1}.json" | jq --arg 'path' "${2}" --arg 'value' "${3}" 'setpath([$path]; $value)' )" > "${1}.json"
  set -x
}

function setpath_json() {
  { set +x; } 2>/dev/null
  echo "$( cat "${1}.json" | jq --arg 'path' "${2}" --argjson 'value' "${3}" 'setpath([$path]; $value)' )" > "${1}.json"
  set -x
}

# End VSCodium