#!/bin/bash

###############################################################################
# Change these
###############################################################################
NEXTCLOUD_PROVIDER="https://sam.nl.tab.digital"
USERNAME="YOUR NEXTCLOUD USERNAME"
PASSWORD="YOUR NEXTCLOUD PASSWORD"
DEFAULT_FILE="world.zip" # do not change
###############################################################################

FILE=${1:-}
if [[ -z ${FILE} ]]; then
  FILE=$DEFAULT_FILE
fi

API_URL="$NEXTCLOUD_PROVIDER/remote.php/dav/files/$USERNAME/$FILE"
printf "\e[44m[$(date +%T)]\x1b[0m Downloading from $API_URL\n"

curl "${API_URL}" \
  -u $USERNAME:$PASSWORD \
  --output "$FILE"
if [[ ${FILE} =~ \.zip$ ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Extracting $FILE. "
  jar xf $FILE
  printf "Done."
fi