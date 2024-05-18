#!/bin/bash

script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh
work_dir=$script_dir/../
repo_file=$work_dir"patches/repos.txt"
ignore_merge_errors=$1
extra_patch_suffix=$2

read_repos $repo_file 
cd $work_dir"extensions"

for repo in "${read_repos_val[@]}"
do
    repo_key=$(read_key $repo)
    repo_value=$(read_value $repo)
    cd ./$repo_key
    
    if [ -f $work_dir"/patches/"$repo_key".txt" ]; then
        echo "Applying $repo_key PRs"
        read_refs $work_dir"/patches/"$repo_key".txt"
        for ref in "${read_refs_val[@]}"
        do
            cherry_pick_pr $ref $ignore_merge_errors
        done
    fi

    # add extra patches
    if [ ! -z "$extra_patch_suffix" ]; then
        extra_key=$repo_key"."$extra_patch_suffix".txt"

        if [ -f $work_dir"/patches/"$extra_key".txt" ]; then
            echo "Applying $extra_key PRs"
            read_refs $work_dir"/patches/"$extra_key".txt"
            for ref in "${read_refs_val[@]}"
            do
                cherry_pick_pr $ref $ignore_merge_errors
            done
        fi
    fi

    # apply patch files
    apply_git_patches_by_regex $work_dir $repo_key

    cd ../
done
cd $work_dir
