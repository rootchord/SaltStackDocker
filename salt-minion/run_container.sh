#!/bin/bash
docker run -d -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp/$(mktemp -d):/run --name=salt-minion --hostname=salt-minion --network NWsalt local/c7-systemd-salt-minion
