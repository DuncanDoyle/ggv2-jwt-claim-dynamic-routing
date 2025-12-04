#!/bin/sh

# To generate a JWT, use the jwt command-line tool, referencing the private key created earlier. 
# Headers and claims can be added as required via the -header and -claim options.

PRIVATE_KEY_PATH=$1
KID=$2
SUBJECT=$3
TEAM=$4
ROUTE=$5

if [ -z "$PRIVATE_KEY_PATH" ] || [ -z "$KID" ] || [ -z "$SUBJECT" ] || [ -z "$TEAM" ] || [ -z "$ROUTE" ]; then
    echo "Usage: $0 <private_key_path> <kid> <subject> <team> <route>"
    exit 1
fi

EXPIRY_DATE=$(gdate -d "+24hours" +%s)
#Creating the payload manually, which makes it a bit easeur 
PAYLOAD=$(jq -n --arg sub "$SUBJECT" --arg team "$TEAM" --arg route "$ROUTE" --argjson exp $EXPIRY_DATE \
'{
  "exp": $exp,
  "iss": "solo.io",
  "org": "solo.io",
  "sub": $sub,
  "team": $team,
  "route": $route
}')

 echo $PAYLOAD | jwt -key $PRIVATE_KEY_PATH -alg RS256 -header kid=$KID -sign -