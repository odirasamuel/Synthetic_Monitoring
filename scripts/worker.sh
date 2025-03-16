#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

docker pull selenium/hub:4.8.3
docker pull selenium/node-chrome:4.8.3

docker run -d --shm-size="2g" \
  -e SE_EVENT_BUS_HOST=<hub-private-ip> \
  -e SE_EVENT_BUS_PUBLISH_PORT=4442 \
  -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
  -p 5555:5555 \
  --name selenium-node-chrome \
  selenium/node-chrome:4.8.3