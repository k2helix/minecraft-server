#!/bin/bash
json=$(cat server.data)
###############################################################################
# Change these
###############################################################################
NEXTCLOUD_PROVIDER=$(echo $json | jq -r '.provider')
USERNAME=$(echo $json | jq -r '.username')
PASSWORD=$(echo $json | jq -r '.password')
DEFAULT_FILE="world.zip" # do not change
###############################################################################

FILE=${1:-}
if [[ -z ${FILE} ]]; then
  FILE=$DEFAULT_FILE
fi

if [[ -d ${FILE} ]]; then
  printf "[Debug] $FILE is a directory.\n"
  FILE=${FILE}.zip
fi

API_URL="$NEXTCLOUD_PROVIDER/remote.php/dav/files/$USERNAME/MinecraftServer/$FILE"
printf "\e[44m[$(date +%T)]\x1b[0m Downloading from $API_URL\n"

curl "${API_URL}" \
  -u $USERNAME:$PASSWORD \
  --output "$FILE"

if [[ ${FILE} =~ \.zip$ ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Extracting $FILE. "
  jar xf $FILE
  printf "Done.\n"
  rm -f ${FILE::-4}/uploaded* ${FILE::-4}/downloaded*
fi

if [[ $FILE == "server.zip" ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Setting up server.\n"
  mv -f server/* ./
fi

rm $FILE

# same as with upload.sh
if [[ -d ${FILE::-4} ]]; then
  touch "${FILE::-4}/downloaded$(date +%s)"
fi