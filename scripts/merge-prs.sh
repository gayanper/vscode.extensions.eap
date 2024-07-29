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

    echo "patching repostory $repo_key"
    
    if [ -f $work_dir"/patches/"$repo_key".txt" ]; then
        echo "Applying $repo_key PRs"
        read_refs $work_dir"/patches/"$repo_key".txt"
        for ref in "${read_refs_val[@]}"
        do
            cherry_pick_pr $ref $ignore_merge_errors
        done
    fi
    
    echo
    if [ ! -z "$extra_patch_suffix" ]; then
        extra_key=$repo_key"."$extra_patch_suffix
        # pull any extra branches into before start applying extra patches
        extra_pull_file=$work_dir"/patches/pull."$extra_key".txt"
        if [ -f $extra_pull_file ]; then
            entries=$(read_entries $extra_pull_file)
            for pull_entry in $entries
            do
                pull_branch=$(read_key $pull_entry)
                pull_url=$(read_value $pull_entry)
                echo "pulling branch:$pull_branch from repo:$pull_url into $repo_key"

                git pull -Xtheirs --no-rebase --no-edit $pull_url $pull_branch
                if [[ $? -ne 0 ]]; then
                    echo "::error:: Fail to pull branch: $pull_branch, ignoring."
                fi
            done
        fi
    
        echo
        extra_patch_file=$work_dir"/patches/"$extra_key".txt"
        # add extra patches
        if [ -f $extra_patch_file ]; then
            echo "Applying $extra_key PRs"
            read_refs $extra_patch_file
            for ref in "${read_refs_val[@]}"
            do
                cherry_pick_pr $ref $ignore_merge_errors
            done
        fi
    fi

    echo
    # apply patch files using pattern /patches/"<reponame>".*.patch
    if [ ! -z "$extra_patch_suffix" ]; then
        extra_key=$repo_key"."$extra_patch_suffix
        apply_git_patches_by_regex $work_dir $extra_key
    else
        apply_git_patches_by_regex $work_dir $repo_key
    fi

    cd ../
    echo
    echo
done
cd $work_dir
