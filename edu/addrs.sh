#!/bin/sh
for hostname in $(zq -f text 'by Website' zson/schools.zson | sed 's/^http:\/\///' | sed 's/\/.*$//' | sort | uniq | grep -v "\-" | less)
do
  addr=$(dig +noall +answer $hostname | grep "\tA\t" | awk '{ print $5 }' | head -1)
  if [ -n "$addr" ]; then
    echo "{\"Website\":\"$hostname\",addr:$addr}"
  fi
done
