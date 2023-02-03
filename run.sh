#!/bin/sh

echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting dnsmasq"
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Updating blocklists..."
wget --no-cache https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt -O /blocklists/hostnames.txt
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Hostnames blocklist updated"
wget --no-cache https://raw.githubusercontent.com/notracking/hosts-blocklists/master/domains.txt -O /blocklists/domains.txt
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Domains blocklist updated"
if [ ! -f ${CONF_DIR}/dns.conf ]; then echo "$(date +'[%Y-%m-%d %H:%M:%S]') ${CONF_DIR}/dns.conf not found. Use default dns.conf"; cp ${SAMPLE_CONF_DIR}/dns.conf ${CONF_DIR}; fi
if [ ! -f ${CONF_DIR}/dhcp.conf ]; then echo "$(date +'[%Y-%m-%d %H:%M:%S]') ${CONF_DIR}/dhcp.conf not found. Use default dhcp.conf"; cp ${SAMPLE_CONF_DIR}/dhcp.conf ${CONF_DIR}; fi
echo "${BLOCKLISTS_UPDATE_SCHEDULE} /sbin/reboot" > /etc/crontabs/root
/usr/sbin/crond
/usr/sbin/dnsmasq --keep-in-foreground
