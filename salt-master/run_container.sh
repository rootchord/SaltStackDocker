#!/bin/bash
docker run -d -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp/$(mktemp -d):/run --name salt --hostname salt -p 4505:4505 -p 4506:4506 --network NWsalt local/c7-systemd-salt-master
