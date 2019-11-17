# SaltStackDocker
salt-master and minion in docker based on CentOS7.

## Installation
Build images
```
docker build --rm -t local/c7-systemd c7-systemd/.
docker build --rm -t local/c7-systemd-salt-master salt-master/.
docker build --rm -t local/c7-systemd-salt-minion salt-minion/.
```
c7-systemd is used as a base for the other images because we are going to use systemd functions.
Reference: https://hub.docker.com/_/centos/

Setup network
```
docker network create NWsalt
docker network list
docker network inspect NWsalt
```

## Usage
Start container from their script
```
./salt-master/run_container.sh
./salt-minion/run_container.sh
```

It spawns 2 container with name 'salt' (master) and 'salt-minion'.
