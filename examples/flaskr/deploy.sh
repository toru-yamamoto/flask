#!/bin/bash

docker push $REGISTRY

old_id=`cf ic ps | grep $REGISTRY | awk '{print $1}'`
echo "Old Container ID: $old_id"

public_ip=`cf ic inspect $id | jq -r '.[0].NetworkSettings.PublicIpAddress'`
echo "Public IP: $public_ip"

echo "Unbind public IP from old container"
cf ic ip unbind $ip $id

echo "Run new container"
new_id=`cf ic run -p 80 $REGISTRY`
echo "New Container ID: $new_id"

echo "Bind public IP to new container"
cf ic ip unbind $ip $id

echo "Delete old container"
cf ic rm -f $id
