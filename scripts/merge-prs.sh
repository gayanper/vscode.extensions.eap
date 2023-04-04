#!/bin/bash

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

    echo "Apply git patch files for $repo_key"
    patch_pattern=$work_dir"/patches/"$repo_key"*.patch"
    
    for p in $(ls $patch_pattern 2>/dev/null)
    do
        echo "Applying patch file $p"
        git apply --apply $p && git add . && git commit -m "Patch $p"
        if [[ $? -ne 0 ]]; then
            echo "::error:: Fail to apply patch: $p"
            exit 100
        fi        
    done

    echo "Applying $repo_key PRs"
    read_refs $work_dir"/patches/"$repo_key".txt"
    for ref in "${read_refs_val[@]}"
    do
        cherry_pick_pr $ref
    done
    cd ../
done
cd $work_dir
