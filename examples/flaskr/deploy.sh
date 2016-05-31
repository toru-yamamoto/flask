#!/bin/bash

docker push $REGISTRY

id=`cf ic ps | grep $REGISTRY | awk '{print $1}'`
echo $id

ip=`cf ic inspect $id | jq -r '.[0].NetworkSettings.PublicIpAddress'`
echo $ip

cf ic ip unbind $ip $id
cf ic run -p 80 $REGISTRY
cf ic rm -f $id
