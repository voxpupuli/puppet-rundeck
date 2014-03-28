#!/usr/bin/env sh

bundle exec rake test

for i in `ls -l spec/acceptance/nodesets/ | awk '{if (NR>1)print $9}' | grep -v default.yml | sed -e 's/\.yml//g'`
do
  BEAKER_set=$i BEAKER_debug=yes bundle exec rspec spec/acceptance
done