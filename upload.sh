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

if [[ $FILE == "server.zip" ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Preparing server upload.\n"
  mkdir -p server
  cp -r *.sh *.json server.{properties,jar,data} binaries/ server/
fi

if [[ ${FILE} =~ \.zip$ ]]; then
  printf "\e[44m[$(date +%T)]\x1b[0m Compressing ${FILE::-4} into $FILE. "
  rm -f ${FILE::-4}/uploaded* ${FILE::-4}/downloaded*
  jar -cfM $FILE ${FILE::-4}
  printf "Done.\n"
fi

if [[ ! -e ${FILE} ]]; then
  printf "No such file or directory: %s\n" "${FILE}"
  exit 1
fi

API_URL="$NEXTCLOUD_PROVIDER/remote.php/dav/files/$USERNAME/MinecraftServer/$FILE"
printf "\e[44m[$(date +%T)]\x1b[0m Uploading to $API_URL\n"

curl "${API_URL}" \
  --request PUT \
  -o /dev/null \
  -u $USERNAME:$PASSWORD \
  -T $FILE \
  -i

rm $FILE

# This is here for check.sh to correctly detect if the world is up to date with the server; 
# else it would fail when uploading the world as the latest change local date would be lower
# than the server date as it is uploaded after the latest change when the server stops.
if [[ -d ${FILE::-4} ]]; then
  touch "${FILE::-4}/uploaded$(date +%s)"
fi