#!/bin/bash

SITE=$1
TYPE=$2

if [ "$TYPE" == "discover" ]; then

#	jq -r '.results[] | select(.comments | contains("'"$SITE"'")) | .name' /tmp/ipsec.json | wc -l

#cat /tmp/ipsec.json|jq -r '.results[] | [.comments] | @tsv'|awk -F"_" '{print $1}' | sed '/^$/d'|sort|uniq > /tmp/dump-site.csv
cat /tmp/ipsec.json|jq -r '.results[] | [.comments] | @tsv'|grep "_x_"|awk -F"_" '{print $1}' | sed '/^$/d'|sort|uniq > /tmp/dump-site.csv

echo -n '{"data":[';cat /tmp/dump-site.csv|while read line;do echo -n "{\"{#SITIO}\": \"$line\"},";done|sed -e 's:\},$:\}:';echo -n ']}';

else

	jq -r '.results[] | select(.comments | contains("'"$SITE"'")) | select(.proxyid[].status == "up") | .name' /tmp/ipsec_raw.json | wc -l

fi
