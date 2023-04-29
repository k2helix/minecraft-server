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
  # printf "[Debug] $FILE is a directory.\n"
  FILE=${FILE}.zip
fi

API_URL="$NEXTCLOUD_PROVIDER/remote.php/dav/files/$USERNAME/MinecraftServer/$FILE"
# printf "\e[44m[$(date +%T)]\x1b[0m Checking latest $FILE update\n"

server_date=$(curl "${API_URL}" \
  --request PROPFIND \
  -u $USERNAME:$PASSWORD \
  -s | grep -oP '(?<=<d:getlastmodified>).*?(?=</d:getlastmodified>)')

server_timestamp=$(date -d "$server_date" +%s)

if [[ ! -e ${FILE} ]] && [[ ! -d ${FILE::-4} ]] && [[ $(date -d 'today 00:00:00' +%s) == $server_timestamp ]]; then
  echo "No such file or directory found in the cloud: ${FILE}"
  echo -e "\e[33mIf it is a folder and it's the first time you download it, check its .zip instead\e[0m"
  exit 1
elif [[ $(date -d 'today 00:00:00' +%s) != $server_timestamp ]] && [[ ! -e ${FILE} ]] && [[ ! -d ${FILE::-4} ]]; then
  echo "The file $FILE was not found, but it is on the server. Do you want to download it? (yes/no)"
  read download
  if [[ "$download" =~ ^[Yy][Ee][Ss]?$ ]]; then
    ./download.sh $FILE
  else
    echo "Good luck out there."
  fi
  exit 0;
fi

local_timestamp=$(stat -c %Y "${FILE::-4}")

server_date=$(date -d @$server_timestamp +'%d/%m/%Y %H:%M:%S')
local_date=$(date -d @$local_timestamp +'%d/%m/%Y %H:%M:%S')

if (( $server_timestamp > $local_timestamp )); then
  echo -e "The server version of $FILE was modified on \e[32m$server_date\e[0m, which is newer than the local version (\e[31m$local_date\e[0m.)"
  echo "Do you want to download the latest uploaded version? (yes/no)"
  read confirm
  if [[ "$confirm" =~ ^[Yy][Ee][Ss]?$ ]]; then
    ./download.sh $FILE
  else
    echo "Good luck out there."
  fi
else
  echo -e "The local version of $FILE was modified on \e[32m$local_date\e[0m, and is up to date with the server version (\e[32m$server_date\e[0m)."
fi