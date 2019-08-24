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

Tag to use along host architecture:

| Architecture | Tag to use |
|---|---|
| x86-64 | latest |
| arm | latest-armhf |

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

On startup, Masquarade will create `dns.conf` & `dhcp.conf` files into volume `/etc/dnsmasq.d/` (only if they don't exists). These two files are `dnsmasq` related config files. 

Edit them according your needs. [The dnsmasq manual might help you](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html).

**To apply changes**, simply restart the container:

```
docker restart masquarade
```
or

```
docker-compose restart masquarade
```
## dns.conf default config

```
# Common
domain-needed                       # Do NOT forward queries with no domain part
bogus-priv                          # Fake reverse lookups for RFC1918 private address ranges
filterwin2k                         # Don't forward spurious DNS requests from Windows hosts.
expand-hosts                        # Expand simple names in /etc/hosts with domain-suffix.
no-negcache                         # Do NOT cache failed search results
no-resolv                           # Do NOT read /etc/resolv.conf. @see servers
no-hosts                            # Do NOT load /etc/hosts file
strict-order                        # Use nameservers strictly in the order given in /etc/resolv.conf
localise-queries                    # Answer DNS queries based on the interface a query was sent to.

# Domain, replace with your domain
local=/lan/
domain=lan

# Optionnal: allow resolution of *.yoursubdomain.lan to the same ip_addr
#address=/yoursubdomain.lan/[ip_addr]    

# Default forwarders
server=1.1.1.1                      # Cloudflare primary, replace with yours
server=1.0.0.1                      # Cloudflare secondary, replace with yours
```

## dhcp.conf default config

```
dhcp-authoritative  # Assume we are the only DHCP server on the local network

# Scope DHCP
dhcp-range=192.168.0.0,192.168.0.20,24h # Lease time = 24h

# DHCP Options given to each client.
dhcp-option=3,192.168.0.1 # Default Gateway
dhcp-option=1,255.255.255.0 # Netmask
dhcp-option=6,192.168.0.1 # DNS Server (should be your docker host ip)

# Static DHCP config. 
# E.g. dhcp-host=[mac_addr],[hostname],[ip_addr]
dhcp-host=aa:bb:cc:dd:ee:ff,myhostname,192.168.0.100
```

# Custom configuration

Simply add your `.conf` config file into your mapped volume linked to `/etc/dnsmasq.d/`. This file must be `dnsmasq` compliant. [The dnsmasq manual might help you](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html).

When done restart your container to apply changes
