###############################################################################
# Change these
###############################################################################
JAVA_BINARY="java"
WEBHOOK_URL="YOUR WEBHOOK URL"
###############################################################################

url="$(ngrok tcp 25565 > /dev/null & sleep 5 && curl "127.0.0.1:4040/api/tunnels/command_line" --silent | jq -r .public_url)";
echo $url
curl "$WEBHOOK_URL" \
 --silent \
 --request POST \
 --header "Content-Type: application/json" \
 --data "{\"embeds\":[{\"color\":59389,\"description\":\"The server ip is $url\"}]}" \ 
"$JAVA_BINARY" -jar server.jar
