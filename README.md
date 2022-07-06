## What is this?
This repo contains 3 files which you can use to host and share (with a dynamic ip) a Minecraft server on your PC or wherever you want.
- start.sh: This is the file you need to execute when you want to start the server. You can find some configurable options in it and you can set a Discord webhook url to send the server ip there.
- upload.sh: This file is used to upload the current world to the cloud (Nextcloud), so someone on a different machine can download it later to continue playing. (not needed if the host is going to be the same always). It may also be used as a backup to restore it (by downloading) if something weird happens.
- download.sh: This file is used to download the current uploaded world from the cloud (Nextcloud). It will replace the current "world" directory so make sure that you don't download if your current progress is higher than the uploaded's world one to avoid losing progress
 
## Requirements
- You need a [ngrok](https://ngrok.com/) authtoken which you can get for free on their site
- You need the [ngrok executable](https://ngrok.com/download) ([on PATH if you're on Windows](https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows))
- You need [jq](https://stedolan.github.io/jq/download/) 1.6 (on PATH if you're on Windows)
- You need the Minecraft server jar of the version you want to play (named server.jar)
- The [Java Development Kit](https://www.oracle.com/java/technologies/java-se-glance.html) required by the minecraft server version.
- In order to use the download and upload functions, you also need a Nextcloud account from some provider ~[this one](https://sam.nl.tab.digital) gives 8GB of storage for free. Configure your settings in both files.
- On Windows, you will also need [Git](https://git-scm.com/) Bash in order to run .sh files.

## Installation
First make sure to have all the needed requirements installed and on PATH (check if you can call "ngrok", "jq", "java" and "jar" from the command line). Also make sure the minecraft server jar of the version you are going to play works with your JAVA_BINARY, else everything else will fail.
1. Set the different options which you can find below
2. Set your ngrok authtoken by using `ngrok authtoken <authtoken>` in a terminal
4. Run start.sh

### Options
You can set different options in the files.
- JAVA_BINARY: path to the java executable/binary (useful if you have different java versions). **Note that specific minecraft versions require specific java versions** (for example Minecraft 1.17 requires JAVA SE Development Kit >=16).
- WEBHOOK_URL: url of a Discord webhook of the channel where you want the server ip to be sent. If you don't want to set one leave it blank and delete from line 10 to 14 of start.sh (the ip is also logged in the command line).
- NEXTCLOUD_PROVIDER: the nextcloud provider url you chose for the cloud saving (download.sh and upload.sh files). Consider using [one with a good amount of storage](https://sam.nl.tab.digital) as minecraft worlds are usually big in terms of size. 

### Notes
Note that ngrok only allows 3 tunnels at the same time, so if you started the server a few times and now you are not getting the server ip, it is highly possible that they're already started. In this case, you can kill the ngrok process and run the start file again.