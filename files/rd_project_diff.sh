#!/usr/bin/bash

project="$1"
update_method="$2"
config="$3"
keys="$4"

if [[ $update_method == 'update' ]]
then
    query="jq -S 'with_entries(select(.key as \$k | \"$keys\" | index(\$k)))'"
else
    query='jq -S'
fi

bash -c "diff <(rd projects configure get -p '$project' | $query) <(echo '$config' | jq -S)"
