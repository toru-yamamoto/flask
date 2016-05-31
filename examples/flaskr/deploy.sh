#!/bin/bash

registry=$1
bluemix_registry=$2

docker tag -f $registry $bluemix_registry:$CIRCLE_SHA1
docker push $bluemix_registry:$CIRCLE_SHA1

old_id=`cf ic ps | grep $bluemix_registry | awk '{print $1}'`
echo "Old Container ID: $old_id"

public_ip=`cf ic inspect $old_id | jq -r '.[0].NetworkSettings.PublicIpAddress'`
echo "Public IP: $public_ip"

echo "Unbind public IP from old container"
cf ic ip unbind $public_ip $old_id

echo "Run new container"
new_id=`cf ic run -p 80 $bluemix_registry:$CIRCLE_SHA1`
echo "New Container ID: $new_id"

echo "Bind public IP to new container"
cf ic ip bind $public_ip $new_id

echo "Delete old container"
cf ic rm -f $old_id
