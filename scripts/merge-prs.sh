#!/bin/bash
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

# script start here
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh
work_dir=$script_dir/../
repo_file=$work_dir"patches/repos.txt"

read_repos $repo_file 
cd $work_dir"extensions"

for repo in "${read_repos_val[@]}"
do
    repo_key=$(read_key $repo)
    repo_value=$(read_value $repo)
    cd ./$repo_key

    echo "Applying $repo_key PRs"
    read_refs $work_dir"/patches/"$repo_key".txt"
    for ref in "${read_refs_val[@]}"
    do
        cherry_pick_pr $ref
    done
    cd ../
done
cd $work_dir
