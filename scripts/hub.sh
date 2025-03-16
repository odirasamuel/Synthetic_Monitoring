#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

docker pull selenium/hub:4.8.3
docker pull selenium/node-chrome:4.8.3

docker run -d -p 4444:4444 --name selenium-hub selenium/hub:4.8.3