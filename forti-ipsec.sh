#!/bin/bash

HOST=$1
TOKEN=$2
TYPE=$3
SITE=$4

if [ "$TYPE" == "discover" ]; then

curl -s -k -X GET "https://$HOST/api/v2/monitor/vpn/ipsec?access_token=$TOKEN" > /tmp/ipsec.json

cat /tmp/ipsec.json|jq -r '.results[] | [.name,.comments] | @csv' > /tmp/dump.csv

cat /tmp/dump.csv | awk -F\" '{print $4}'|cut -d"_" -f1|sed '/^$/d'|sort|uniq| while read line
    do
        sed -i "/.*$line.*/ s/$/\,\"$line\"/" /tmp/dump.csv
    done

echo -n '{"data":[';cat /tmp/dump.csv|while IFS=, read tunnel comment site count;do echo -n "{\"{#TUNNEL}\": $tunnel, \"{#COMMENT}\": $comment, \"{#SITE}\": $site},";done|sed -e 's:\},$:\}:';echo -n ']}';

else

curl -s -k -X GET "https://$HOST/api/v2/monitor/vpn/ipsec?access_token=$TOKEN" > /tmp/ipsec_raw.json
cat /tmp/ipsec_raw.json

fi
