#!/usr/bin/env bash


#This script adds the beat agent to a new machine and starts the agent pointing it to a Elastic Cloud instance.
# You just need to add the cloud-id of the instance and authentication credentials.
export cloud_id="XXXXX"
export cloud_auth="XXXXXX"


curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.10.0-amd64.deb
dpkg -i filebeat-7.10.0-amd64.deb

curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-7.10.0-amd64.deb
dpkg -i packetbeat-7.10.0-amd64.deb

curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.10.0-amd64.deb
dpkg -i auditbeat-7.10.0-amd64.deb



export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $OSQUERY_KEY
add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main'
apt-get  update
apt-get install osquery -y


id=$(($RANDOM*$RANDOM))
filebeat  -E cloud.id=$cloud_id -E cloud.auth=$cloud_auth   -E tags="[$id]"  --modules system,osquery  &
packetbeat  -E cloud.id=$cloud_id -E cloud.auth=$cloud_auth   -E tags="[$id]"   &
auditbeat -E cloud.id=$cloud_id -E cloud.auth=$cloud_auth   -E tags="[$id]"  &
