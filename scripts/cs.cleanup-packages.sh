#!/bin/bash
# The script assume that the CLOUDSMITH_API_KEY is set and packages are ordered chronologically.
readonly REPO="gap/vsce"

IFS=$'\n'
name=$1
keep=$2
if [ -z $name ]; then
    echo "Package name is required"
    exit 1
fi
if [ -z $keep ]; then
    keep="2"
fi

package_list=($(cloudsmith list packages $REPO -q "name:^$name-" -F json | jq -R 'fromjson? | .data[].slug'))
length=${#package_list[*]}
if [[ length -lt keep ]]; then
    exit 0
fi

to_delete=("${package_list[@]:$(($keep))}")
for pkg_name in "${to_delete[@]}"; do
    cloudsmith delete $REPO/$(echo $pkg_name | xargs) -y
done

