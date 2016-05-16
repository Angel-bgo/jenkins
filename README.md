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

## Backup & Restore
* [beckup](https://wiki.jenkins-ci.org/display/JENKINS/Administering+Jenkins) - example [script](scripts/backup.sh)
* [restore](https://documentation.cloudbees.com/docs/cje-user-guide/backup-sect-restore.html)

## Jenkins setup

`Jenkins -> Manage Jenkins -> Manage Plugins`
Install following plugins:
* [Git plugin](https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin])
* [CloudBees Docker Custom Build Environment Plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Custom+Build+Environment+Plugin)

## New project setup
* make sure `Build inside a Docker container` is checked
* Docker image from repository: `bgosoftware/cidocker:1`
* make sure `Run in privileged mode` is checked
* User group should be `docker`
* Add volume. Container will use docker from host.
```
Path on host: /var/run/docker.sock
Path inside container: /var/run/docker.sock
```

Example shell build step
```
docker run -v ${PWD}:/project -i php:7.0-cli php /project/examples/simplePhp.php && \
docker run -v ${PWD}:/project -i php:5.6-cli php /project/examples/simplePhp.php
```

## Security
* Install `Build Authorization Token Root Plugin` (Build Token Root Plugin)
* Manage Jenkins -> Configure Global Security
* Check `Enable security`
* Security Realm: Jenkins’ own user database
* check `Allow users to sign up`
* Authorization: `Anyone can do anything`
* Save.
* Register new account (top-right corener) - http://jenkins.local:8080/signup
* Manage Jenkins -> Configure Global Security
* Authorization:  Matrix-based security	
* add you user (admin). Give all permissions to your user. Remove all permission from `Anonymous`
* uncheck `Allow users to sign up`
* In project configuration (Jenkins->Project1->Configure) create Build Triggers -> Trigger builds remotely -> Enter Authentication Token	(e.g. mySecretToken13 )
Build could be triggered from url
```
curl -XPOST 'http://192.168.11.163:8080/buildByToken/build?job=PROJECTNAME&token=TOKEN'
example:
curl -XPOST 'http://192.168.11.163:8080/buildByToken/build?job=project1&token=mySecretToken13'
```

## Mail configuration
```
Manage Jenkins -> Configure System ->
                              -> System Admin e-mail address -> [enter mail used by jenkins]
                              -> E-mail Notification -> Fill all required fields (including Advanved)

