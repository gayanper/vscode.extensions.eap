#!/bin/bash
function read_repos {
    read_repos_val=()
    local file_path=$1
    while IFS='=' read -r key value || [ -n "$key" ]
    do
        if [[ $key != \#* ]]; then
            read_repos_val+=("$key:$value")
        fi
    done < "$file_path"
}

function read_refs {
    read_refs_val=()
    local file_path=$1
    while IFS= read -r ref || [ -n "$ref" ]
    do
        read_refs_val+=("$ref")
    done < "$file_path"
}

function read_key {
    echo ${1%%:*}
}

function read_value {
    echo ${1#*:}
}

function cherry_pick_pr {
    echo "Applying PR # : $1"
    mainBranch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    gh pr checkout $1 -b b$1 && git switch $mainBranch

    if [[ $? -ne 0 ]]; then
        echo "::error:: Fail to checkout PR: $1 , ignoring."
    fi

    git merge b$1
    
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
            echo "::warning:: Detected a conflict while applying: $1, ignoring patch."
        fi
    fi       
}

