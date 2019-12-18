#!/bin/bash
set -e

if [ $# -ne 1 ] || ! { [ "$1" = "zson" ] || [ "$1" = "bzson" ]; }; then
  echo 'Must specify output type to be cheecked: "zson" or "bzson"'
  exit 1
fi

ZNG_TYPE="$1"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)/.."
cd "$REPO_DIR"
TMPFILE=$(mktemp)

for FILE in "$REPO_DIR"/"$ZNG_TYPE"/*
do
  COMPARE_TO="$(basename "$FILE")"
  ZPATH=${COMPARE_TO/.${ZNG_TYPE}.gz/}
  echo -n "${ZPATH}:" | tee -a "$TMPFILE"
  gzcat zeek-default/"$ZPATH".log.gz | zq -f "$ZNG_TYPE" - | md5sum | awk '{ print $1 }' | tee -a "$TMPFILE"
done

echo
echo "diff'ing current \"zq -f $ZNG_TYPE\" output hashes vs. committed hashes:"
RET=0
diff "$TMPFILE" md5sums/"$ZNG_TYPE" || RET="$?"
echo
if [ "$RET" = 0 ]; then
  echo "  ======> No diffs found. $ZNG_TYPE outputs have not changed."
  rm -f "$TMPFILE"
else
  echo "  ======> diffs detected! Check for a zq bug or intentional $ZNG_TYPE format change."
  echo "          Current hashes are in $TMPFILE"
  exit 1
fi
