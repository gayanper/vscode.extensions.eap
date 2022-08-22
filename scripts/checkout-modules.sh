#!/bin/bash

function clone_repo {
    echo "cloning $1 into $2"
    git clone $1 $2
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

