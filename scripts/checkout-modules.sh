#!/bin/bash

function clone_repo {
    echo "cloning $1 into $2"
    git clone --depth=1 $1 $2 && git -C $2 checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
}


# script start here
script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

# preparation
work_dir=$script_dir/../
cd $work_dir
repo_file=$work_dir"patches/repos.txt"

mkdir ./extensions/
cd ./extensions

# cloning repositories
echo "cloning modules"
#read_repos_val is the result holding variable
read_repos $repo_file 
for r in "${read_repos_val[@]}"
do
    clone_repo $(read_value $r) $(read_key $r)
done
cd ../

