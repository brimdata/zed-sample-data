#!/bin/bash
set -eo pipefail

if (($# !=  1)) || ! [[ $1 == bsup || $1 == bsup-uncompressed || $1 == sup ]]; then
  echo 'Must specify output format to be checked: "bsup", "bsup-uncompressed", or "sup"'
  exit 1
fi

if [[ $(type -P "gzcat") ]]; then
  ZCAT="gzcat"
elif [[ $(type -P "zcat") ]]; then
  ZCAT="zcat"
else
  echo "gzcat/zcat not found in PATH"
  exit 1
fi

if [[ $(type -P "md5sum") ]]; then
  SUMTOOL="md5sum"
elif [[ $(type -P "md5") ]]; then
  SUMTOOL="md5 -q"
else
  echo "md5sum/md5 not found in PATH"
  exit 1
fi

SUPER_TYPE="$1"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)/.."
cd "$REPO_DIR"
TMPFILE=$(mktemp)

for FILE in "$REPO_DIR"/"$SUPER_TYPE"/*
do
  COMPARE_TO="$(basename "$FILE")"
  if [ "$SUPER_TYPE" == "bsup-uncompressed" ];then
    ZQ_CMD="super -f bsup -bsup.compress=false -"
    ZPATH=${COMPARE_TO/.bsup.gz/}
  else
    ZQ_CMD="super -f $SUPER_TYPE -"
    ZPATH=${COMPARE_TO/.${SUPER_TYPE}.gz/}
  fi
  echo -n "${ZPATH}:" | tee -a "$TMPFILE"
  "$ZCAT" zeek-default/"$ZPATH".log.gz \
      | $ZQ_CMD \
      | $SUMTOOL \
      | awk '{ print $1 }' \
      | tee -a "$TMPFILE"
done

echo -e "\ndiff'ing current \"$SUPER_TYPE\" output hashes vs. committed hashes:"
if ! diff "$TMPFILE" md5sums/"$SUPER_TYPE"; then
  echo "  ======> diffs detected! Check for a zq bug or intentional $SUPER_TYPE format change."
  echo "          Current hashes are in $TMPFILE"
  exit 1
fi

echo -e "\n  ======> No diffs found. $SUPER_TYPE outputs have not changed."
rm -f "$TMPFILE"
