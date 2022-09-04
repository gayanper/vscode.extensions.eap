#!/bin/bash

script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
source $script_dir/common.sh

work_dir=$script_dir/../
cd $work_dir"vscode"

read_refs $work_dir"/patches/vscode.txt"
for ref in "${read_refs_val[@]}"
do
    cherry_pick_pr $ref
done

cd $work_dir
