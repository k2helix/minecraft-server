## What is this?
This repo contains various files which you can use to host and share a Minecraft server on your PC or wherever you want.
- init.sh: This file contains a startup script which you can run to set up your server quickly. It will automatically download some required tools such as java and playit which both need to be in the `binaries` folder for `start.sh` to work if it's not changed.
- start.sh: This is the file you need to execute when you want to start the server. You can find some configurable options in it such as the maximum and minimum RAM and other Java options. It defaults Java and Playit paths to `./binaries/`, which can be downloaded from the `init.sh` script. Else you can just change its path and configure them manually.
- upload.sh: This file is used to upload the current world to the cloud (Nextcloud), so someone on a different machine can download it later to continue playing. (not needed if the host is going to be the same always). It may also be used as a backup to restore it (by downloading) if something weird happens. Mods, config and server files can also be uploaded by specifying it: ./upload.sh world.zip(default)/config.zip/mods.zip/server.zip
- download.sh: This file is used to download the current uploaded world from the cloud (Nextcloud). It will replace the current "world" directory so make sure that you don't download if your current progress is higher than that of the uploaded world to avoid losing progress. Mods, config and server files can also be downloaded by specifying it: ./download.sh world.zip(default)/config.zip/mods.zip/server.zip
- check.sh: This file is used by `start.sh` before starting to check if the uploaded world and the local world are up to date. If the uploaded world was edited more recently than the local, it will offer the user to download it from the cloud. This can also be used to check for mods or config. **Note that this may be a bit buggy. I tested it and it worked fine, but still be aware. It will always ask for your confirmation before doing anything, so make sure you know that whatever you do is right**
 
## Requirements
- A [playit](https://playit.gg/) account which you can get for free on their site.
- A [playit Minecraft tunnel](https://playit.gg/account/tunnels) set.
- [jq](https://stedolan.github.io/jq/download/) 1.6 (on PATH if you're on Windows)
- The Minecraft server jar of the version you want to play (named server.jar)
- The [Java Development Kit](https://www.oracle.com/java/technologies/java-se-glance.html) required by the minecraft server version only if you do not want to use the default `init.sh` downloads to `./binaries/` (17.0.6).
- A Nextcloud account from some provider ~[this one](https://tab.digital/) gives 8GB of storage for free. Configure your settings by running `init.sh`.
- On Windows, you will also need [Git](https://git-scm.com/) Bash in order to run .sh files.

## Installation
First make sure to have all the needed requirements installed and on PATH (check if you can call "jq", "java" and "jar" from the command line). Also make sure the minecraft server jar of the version you are going to play works with your JAVA_BINARY, else everything else will fail.
1. Download `init.sh` and optionally the rest of files
2. Run `init.sh` and complete the setup
4. Run `start.sh` if `server.jar` exists

### Options
You can set different options when running `init.sh`.
- Nextcloud Provider URL: the nextcloud provider url you chose for the cloud saving (download.sh and upload.sh files). Consider using [one with a good amount of storage](https://tab.digital/) as minecraft worlds are usually big.
- Nextcloud Username: the username of your nextcloud account for the given provider.
- Nextcloud Password: the password of your nextcloud account for the given provider. Note that if you use OTP (2 factor authentication) you will need to pass a special access password which you can get from Nextcloud's security tab.

### Notes
As said before, if you want to use your machine's java or playit, just change its path in `start.sh` and link your machine as a playit agent. You may also remove the `-c` argument as playit automatically handles it. If you prefer using `ngrok`, switch to its branch in this same repo.