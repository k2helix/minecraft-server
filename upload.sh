#!/bin/bash

###############################################################################
# Change these
###############################################################################
NEXTCLOUD_PROVIDER="https://cloud.disroot.org"
USERNAME="YOUR NEXTCLOUD USERNAME"
PASSWORD="YOUR NEXTCLOUD PASSWORD"
DEFAULT_FILE="world.zip"
###############################################################################

FILE=${1:-}
if [[ -z ${FILE} ]]; then
  FILE=$DEFAULT_FILE
fi

if [[ ${FILE} =~ \.zip$ ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Compressing ${FILE::-4} into $FILE. "
  jar -cfM $FILE ${FILE::-4}
  printf "Done.\n"
fi

if [[ ! -f ${FILE} ]]; then
  printf "No such file: %s\n" "${FILE}"
  exit 1
fi

API_URL="$NEXTCLOUD_PROVIDER/remote.php/dav/files/$USERNAME/$FILE"
printf "\e[44m[$(date +%T)]\x1b[0m Uploading to $API_URL\n"

curl "${API_URL}" \
  --request PUT \
  -o /dev/null \
  -u $USERNAME:$PASSWORD \
  -T $FILE \
  -i