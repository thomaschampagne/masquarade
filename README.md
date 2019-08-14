<div align="center"><img src="./masquarade.svg" width="250px" style="border: 0px" alt=""/></div>

![Docker Pulls](https://img.shields.io/docker/pulls/thomaschampagne/masquarade.svg) 
![Image Size](https://images.microbadger.com/badges/image/thomaschampagne/masquarade.svg)

# Masquarade
Masquarade is a docker **DHCP & DNS** image able to **block tracking, advertising, analytics & malware servers** for all devices on your LAN when running in a container. 

Masquarade is also able to **block undesired webminers** servers which could **mine crypto money at your expense** on your devices.

Masquarade is based on latest [Alpine Linux](https://hub.docker.com/_/alpine) and [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html). Final image size is **~5MB**.

Masquarade use [notracking/hosts-blocklists](https://github.com/notracking/hosts-blocklists) as blocklists source. Blocklists are updated everyday at 2AM (customisable with BLOCKLISTS_UPDATE_SCHEDULE env variable).

Masquarade is the "elementary version" of **Pi-Hole**. It's a sufficient alternative.

# Installation

## Via docker run

In a terminal with docker, paste below:

```bash
docker run -dit \
    --name masquarade \
    -e TZ="Europe/Paris" \
    -e BLOCKLISTS_UPDATE_SCHEDULE='30 3 * * 0' \
    -v $(pwd)/masquarade/:/etc/dnsmasq.d/ \
    --restart=unless-stopped \
    --network host \
    --cap-add=NET_ADMIN \
    thomaschampagne/masquarade:latest
```

In this example the blocklists will be updated [at 03:30 on Sunday](https://crontab.guru/#30_3_*_*_0) or **30 3 * * 0** in cron format.

## Via docker-compose

Create a `docker-compose.yml` with following content:

```
version: "3"
services:
  masquarade:
    image: thomaschampagne/masquarade:latest
    container_name: masquarade
    restart: unless-stopped
    environment:
      - TZ=Europe/Paris
      - BLOCKLISTS_UPDATE_SCHEDULE=30 3 * * 0
    volumes:
      - $PWD/masquarade/:/etc/dnsmasq.d/
    network_mode: host
    cap_add:
      - NET_ADMIN
```

Then run

```bash
docker-compose up -d
```

And to stop service

```bash
docker-compose down
```

# Build docker image on your own

Clone this repo, then run:

```bash
docker build --no-cache -t masquarade:yourtag .
```

# Configuration
## DNS
## DHCP
## Custom config file

