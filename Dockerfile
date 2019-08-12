FROM alpine:latest
LABEL maintener="Thomas Champagne"
ENV BLOCKLISTS_UPDATE_SCHEDULE 0 2 * * *
ENV CONF_DIR /etc/dnsmasq.d/
ENV SAMPLE_CONF_DIR /etc/dnsmasq.d.samples/
ENV BLOCKLIST_DIR /blocklists/
RUN apk update \
    && apk --no-cache add dnsmasq tzdata
EXPOSE 53/udp 53/tcp
RUN mkdir -p ${BLOCKLIST_DIR}
RUN mkdir -p ${SAMPLE_CONF_DIR}
COPY dnsmasq.conf /etc/
COPY dns.conf ${SAMPLE_CONF_DIR}
COPY dhcp.conf ${SAMPLE_CONF_DIR}
VOLUME ${CONF_DIR}
CMD echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting dnsmasq" \
    && echo "$(date +'[%Y-%m-%d %H:%M:%S]') Updating blocklists..." \
    && wget --no-cache https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt -O /blocklists/hostnames.txt \
    && echo "$(date +'[%Y-%m-%d %H:%M:%S]') Hostnames blocklist updated" \
    && wget --no-cache https://raw.githubusercontent.com/notracking/hosts-blocklists/master/domains.txt -O /blocklists/domains.txt \
    && echo "$(date +'[%Y-%m-%d %H:%M:%S]') Domains blocklist updated" \
    && if [ ! -f ${CONF_DIR}/dns.conf ]; then echo "$(date +'[%Y-%m-%d %H:%M:%S]') ${CONF_DIR}/dns.conf not found. Use default dns.conf"; cp ${SAMPLE_CONF_DIR}/dns.conf ${CONF_DIR}; fi \
    && if [ ! -f ${CONF_DIR}/dhcp.conf ]; then echo "$(date +'[%Y-%m-%d %H:%M:%S]') ${CONF_DIR}/dhcp.conf not found. Use default dhcp.conf"; cp ${SAMPLE_CONF_DIR}/dhcp.conf ${CONF_DIR}; fi \
    && echo "${BLOCKLISTS_UPDATE_SCHEDULE}  /sbin/reboot" > /etc/crontabs/root \
    && crond \
    && /usr/sbin/dnsmasq --keep-in-foreground