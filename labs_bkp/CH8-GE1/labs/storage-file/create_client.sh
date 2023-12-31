#!/bin/bash

REDIS_IMAGE="registry.ocp4.example.com:8443/redhattraining/redis:6.2"

echo "Creating a redis client to check the queue..."
oc run redis-client \
  --image="${REDIS_IMAGE}" \
  -l=app=client \
  --timeout 60s
echo "Waiting for redis client readiness..."

ready='false'
while [[ $ready != 'true' ]] ; do
   echo "Waiting for redis client readiness..."
   ready=$(oc get pod redis-client -o jsonpath='{.status.containerStatuses[0].ready}')
   sleep 1
done
echo 'Redis client ready!'
