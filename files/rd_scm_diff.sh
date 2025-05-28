#!/bin/sh
# THIS FILE IS MANAGED BY PUPPET

projects_dir="$1"
project="$2"
interaction="$3"

bash -c "diff <(rd projects scm config -p '$project' -i $interaction | jq .config -S) <(cat $projects_dir/$project/scm-$interaction.json | jq .config -S)"
