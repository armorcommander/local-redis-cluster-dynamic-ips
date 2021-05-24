#!/bin/sh
envsubst '$X_REDIS_PORT:$X_REDIS_PORT' < /etc/redis/redis.conf.template > /etc/redis/redis.conf

containerIp=$(hostname -i)
# sed -i "s/bind private_ip.*/bind $containerIp 127.0.0.1 0.0.0.0/" /etc/redis/redis.conf
# sed -i "s/bind private_ip.*/bind $containerIp/" /etc/redis/redis.conf
# sed -i "s/cluster-announce-ip.*/cluster-announce-ip $containerIp/" /etc/redis/redis.conf

redis-server /etc/redis/redis.conf
