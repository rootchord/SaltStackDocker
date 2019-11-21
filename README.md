# SaltStackDocker
salt-master and minion in docker based on CentOS7.
The salt-master auto accepts every minion.

- [SaltStackDocker](#saltstackdocker)
  * [Requirements](#requirements)
  * [Installation](#installation)
    + [docker run](#docker-run)
      - [Usage](#usage)
    + [docker-compose](#docker-compose)
      - [Usage](#usage-1)
  * [OpenShift](#openshift)
    + [Images](#images)
    + [Deployment](#deployment)
## Requirements
It was tested with following components:
 - docker-compose version 1.24.1, build 4667896b
 - Docker version 18.09.7, build 2d0083d
 - Ubuntu 16.04.6 LTS (Linux ubuntu 4.15.0-51-generic #55~16.04.1-Ubuntu)

## Installation
### docker run
Build images
```
docker build --rm -t local/c7-systemd-salt-master salt-master/.
docker build --rm -t local/c7-systemd-salt-minion salt-minion/.
```
centos/systemd is used as a base for the other images because we are going to use systemd functions.
Reference: https://hub.docker.com/_/centos/

Setup network
```
docker network create NWsalt
docker network list
docker network inspect NWsalt
```

#### Usage
Start container from their script
```
./salt-master/run_container.sh
./salt-minion/run_container.sh
```

It spawns 2 container with name 'salt' (master) and 'salt-minion' in the SWsalt network.

### docker-compose
Build salt-master and salt-minion images
```
docker-compose build
```
Start salt-master and 10 salt-minions
```
docker-compose up --scale salt-minion=10 -d
```
Stop everything
```
docker-compose down
```

#### Usage
Start up salt-master + 10 salt-minions
```
root@ubuntu:~/docker# docker-compose up --scale salt-minion=10 -d 
Creating docker_salt-master_1 ... done
Creating docker_salt-minion_1  ... done
Creating docker_salt-minion_2  ... done
Creating docker_salt-minion_3  ... done
Creating docker_salt-minion_4  ... done
Creating docker_salt-minion_5  ... done
Creating docker_salt-minion_6  ... done
Creating docker_salt-minion_7  ... done
Creating docker_salt-minion_8  ... done
Creating docker_salt-minion_9  ... done
Creating docker_salt-minion_10 ... done
```

Start a bash shell on the salt-master and check if all 10 salt-minions are accepted
```
docker-compose exec --index=1 salt-master bash
[root@53da139a3b6e /]# salt-key 
Accepted Keys:
056fe0b7b40f
51ea64046447
69178b5a3b2c
9115f676c6f3
a6a499f239ab
caefb35578af
cbf184292e97
ecd4840094d9
ed89ecfb6805
f5be965317e6
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

Start a bash shell on the 7th salt-minion. adjust the --index= argument to connect to another one.
```
docker-compose exec --index=7 salt-minion bash
[root@f5be965317e6 /]# systemctl status salt-minion
● salt-minion.service - The Salt Minion
   Loaded: loaded (/usr/lib/systemd/system/salt-minion.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2019-11-17 16:57:53 UTC; 4min 9s ago
[...]
```

## OpenShift
### Images
Images are using `centos/systemd` base image, on top of which `salt` packages are installed. There are currently two images available:
* `salt-master`
* `salt-minion`, which currently includes only `centos7` OS

### Deployment
SaltStack is deployed on OpenShift using `make` targets:
* to deploy/undeploy Salt Master, use `make deploy-master` / `make undeploy-master`
* to deploy/undeploy Salt Minion, use `make deploy-minion` / `make undeploy-minion`
* to access Salt Master, use `make exec-master`
All parameters can be configured via `Makefile`
