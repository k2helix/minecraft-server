###############################################################################
JAVA_BINARY="./binaries/jdk-17.0.6/bin/java"
PLAYIT_COMMAND="./binaries/playit/playit -c ./binaries/playit/playit.toml"
export JAVA_TOOL_OPTIONS="-Xms14G -Xmx14G -XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M"
###############################################################################

./check.sh || exit 0;
$PLAYIT_COMMAND > /dev/null & reset && "$JAVA_BINARY" -jar server.jar nogui
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT