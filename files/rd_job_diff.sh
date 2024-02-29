#!/bin/sh
# THIS FILE IS MANAGED BY PUPPET

project="$1"
job="$2"
path="$3"
format="$4"

temp_file=$(mktemp "/tmp/$job.$format.XXXX")

rd jobs list -p "$project" -J "$job" -f "$temp_file" -F $format

cmp -s "$path" "$temp_file"
cmp_status=$?

rm "$temp_file"

exit $cmp_status
