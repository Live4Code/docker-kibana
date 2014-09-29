#!/bin/bash

cd /home
# Loop until confd has updated the logstash config
until confd -onetime -node 'http://'$ETCD_HOST':'$ETCD_PORT  -config-file /etc/confd/conf.d/kibana.toml; do
  echo "[kibana] waiting for confd to refresh config.js (waiting for ElasticSearch to be available)"
  sleep 5
done

nginx -c /etc/nginx/nginx.conf
