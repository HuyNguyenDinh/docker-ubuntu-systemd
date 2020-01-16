Docker Ubuntu Systemd
=====================

This Dockerfile can build containers capable to use systemd.

Branches
--------

This repository has multiple branches that relate to Ubuntu versions.

|Branch |Ubuntu Version |Docker image tag|
|-------|---------------|----------------|
|master |latest (18.04) |latest          |
|xenial |xenial (16.04) |xenial          |

Pull strategy
-------------

The different branches are **not** merged, they live as individual branches.

Manually starting
-----------------

```
docker run \
  --tty \
  --privileged \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
  robertdebock/ubuntu
```
