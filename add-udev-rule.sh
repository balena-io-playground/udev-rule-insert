#!/bin/bash

set -o errexit -o pipefail

# Don't run anything before this source as it sets PATH here
# shellcheck disable=SC1091
source /etc/profile

# Edit this to add your udev rule:
# cat rulefilename | jq -sR . and replace the outside the outside double quotes " with single quotes '
RULE=''

if [ -z "$RULE" ]; then
  echo "FAIL: No RULE set to be inserted"
  exit 1
fi

BASEFILE="/mnt/boot/config.json"
NEWFILE="$BASEFILE.new"

main() {
  jq  ".os.udevRules.\"70\" = \"$RULE\"" "$BASEFILE" > "$NEWFILE"
  if [ "$(jq -e ".os.udevRules.\"70\"" "$NEWFILE")" != "" ] ; then
    mv "$NEWFILE" "$BASEFILE"
    echo "DONE"
  else
    echo "FAIL: ssh key not found in transitory file $BASEFILE"
    exit 1
  fi
}

main
exit 0