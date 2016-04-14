# Jenkins running builds in containers

## Installation

Setup based on debian 8

Docker
```
apt-get purge lxc-docker* ; apt-get purge docker.io*
apt-get update && \
apt-get install -y apt-transport-https ca-certificates && \
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
apt-get update && apt-cache policy docker-engine && \
apt-get install -y docker-engine docker
```

Jenkins
```
apt-get install -y wget git && \
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - && \
echo -e "\ndeb http://pkg.jenkins-ci.org/debian binary/" >> /etc/apt/sources.list && \
apt-get update && apt-get install -y jenkins
```

Add jenkins to docker group
```
usermod -a -G docker jenkins
```
reboot :)

## Jenkins setup

`Jenkins -> Manage Jenkins -> Manage Plugins`
Install following plugins:
* [Git plugin](https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin])
* [CloudBees Docker Custom Build Environment Plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Custom+Build+Environment+Plugin)

## New project setup
* check `Build inside a Docker container`
* check `Run in privileged mode`
* User group should be `docker`
* Add volume. Container will use docker from host.
```
Path on host: /var/run/docker.sock
Path inside container: /var/run/docker.sock
```
