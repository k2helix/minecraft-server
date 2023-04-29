#!/bin/bash

art=(
"+-----------------------------------------------------------------+"
"|   ____                             ____       _                 |"
"|  / ___|  ___ _ ____   _____ _ __  / ___|  ___| |_ _   _ _ __    |"
"|  \___ \ / _ \ '__\ \ / / _ \ '__| \___ \ / _ \ __| | | | '_ \   |"
"|   ___) |  __/ |   \ V /  __/ |     ___) |  __/ |_| |_| | |_) |  |"
"|  |____/ \___|_|    \_/ \___|_|    |____/ \___|\__|\__,_| .__/   |"
"|                                                        |_|      |"
"|                              by: k2helix                        |"
"+-----------------------------------------------------------------+"
)

for line in "${art[@]}"; do
  echo -e "\e[32m$line\e[0m"
  sleep 0.08
done

function write_sequence {
    local message=$1
    local code=${2:-"\e[30m"}
    local delay=${3:-0.04}

    echo -ne "${code}"
    for (( i=0; i<${#message}; i++ )); do
        echo -n "${message:$i:1}"
        sleep $delay
    done
    echo -e "\e[0m"
}

echo
write_sequence "Welcome to the server configuration wizard 👋" "\e[1m\e[34m"
sleep 0.2
write_sequence "Here you will be able to set up your server in a few clicks" "\e[34m"
sleep 0.1
write_sequence "Please note that for this script to work you need to have downloaded the whole server folder, this includes:" "\e[34m"
write_sequence "- all the .sh files (start, init, check, upload, download)" "\e[34m"
write_sequence "- the server jar file named server.jar" "\e[34m"
write_sequence "- the binaries folder" "\e[34m"
write_sequence "If you do not have them, this script will offer you to download everything except the server jar file, which you will need to get yourself." "\e[34m"

paths=("./binaries/" "./binaries/jdk-17.0.6/" "./binaries/playit/" "./download.sh" "./upload.sh" "./start.sh" "./check.sh")

for path in "${paths[@]}"; do
    if [ ! -e "$path" ]; then
        sleep 0.5
        echo
        echo -e "\e[31m$path does not exist.\e[0m"
        sleep 0.5
        write_sequence "It seems that some files do not exist. Do you want to automatically download all the needed files? (yes/no)" "\e[1m\e[33m"
        read download
        if [[ "$download" =~ ^[Yy][Ee][Ss]?$ ]]; then
            echo -e "\e[1mDownloading required files\e[0m"
            curl https://cloud.disroot.org/s/zmcSTEx5AcPtxWa/download/executables.zip -o executables.zip
            echo -ne "\e[1mExtracting files. \e[0m"
            jar xf executables.zip
            rm executables.zip
            echo "Done."
            break
        else
            echo "Aborting."
            exit 1
        fi
    fi
done

sleep 1

if [ ! -e "./server.data" ]; then
    echo
    write_sequence "First, let's set your Nextcloud credentials" "\e[1m\e[35m"
    sleep 0.2
    write_sequence "Please fill out the following form." "\e[35m"
    write_sequence "Note that your input will be saved in a plain file, so do not share it with anyone" "\e[35m"
    sleep 0.5

    echo
    echo -ne "\e[1mNextcloud Provider URL: \e[0m"
    read NEXTCLOUD_PROVIDER
    NEXTCLOUD_PROVIDER="${NEXTCLOUD_PROVIDER:-https://sam.nl.tab.digital}"

    echo -ne "\e[1mNextcloud Username: \e[0m"
    read USERNAME

    echo -ne "\e[1mNextcloud Password: \e[0m"
    read PASSWORD

    echo
    sleep 0.5
    write_sequence "Saving data to server.data" "\e[35m" 
    jq -n --arg provider "$NEXTCLOUD_PROVIDER" --arg username "$USERNAME" --arg password "$PASSWORD" '{ provider: $provider, username: $username, password: $password }' > server.data
    sleep 0.1
    write_sequence "Data saved" "\e[1m\e[35m" 

    sleep 1
fi

echo
write_sequence "Setting up file permissions..." "\e[1m\e[35m"
echo "Setting execute permission for .sh files"
chmod +x *.sh

echo "Setting execute permission for server.jar"
chmod +x server.jar

echo "Setting execute permission for playit binaries"
chmod +x ./binaries/playit/*

echo "Setting execute permission for java binaries"
chmod +x ./binaries/jdk-17.0.6/bin/*

write_sequence "File permissions set" "\e[1m\e[35m" 

sleep 1

if [ ! -s "./binaries/playit/playit.toml" ]; then
    echo
    write_sequence "Next, you will need to link your playit account to this agent." "\e[34m"
    write_sequence "For that, open the URL that you will see in a few seconds and log in to your playit account." "\e[34m"
    echo -ne "\e[1mPlayit URL: \e[0m"
    ./binaries/playit/playit -s -c ./binaries/playit/playit.toml | {
        claim_url=""
        while read line; do
        if [[ "$line" == *"connection authenticated"* ]]; then
            killall playit agent
            write_sequence "Connection authenticated"
        fi
        claim_url=$(echo "$line" | grep -oP 'claim_url=\K[^ ]+')
        if [[ "$claim_url" != "" ]]; then
            echo "$claim_url"
        fi
    done
}

sleep 1
fi

echo
write_sequence "Running cloud checks. You can ignore the yellow warnings" "\e[1m\e[35m"
sleep 0.1

write_sequence "Checking mods folder..." "\e[35m"
./check.sh mods.zip
echo
write_sequence "Checking config folder..." "\e[35m"
./check.sh config.zip
echo
write_sequence "Checking world folder..." "\e[35m"
./check.sh world.zip
echo
write_sequence "Cloud checks done" "\e[1m\e[35m"

sleep 1
echo
write_sequence "Your server has been successfully configured. You can now start it by running start.sh if you already have the server.jar file" "\e[1m\e[34m"
write_sequence "You can also configure max and min RAM usage there, which defaults to 14GB." "\e[34m"
write_sequence "If you want to add mods, it should not be hard considering you have arrived here. You would just have to rename the mod loader jar to server.jar and create a mods folder" "\e[34m"
write_sequence "That's it. Good luck out there." "\e[34m"