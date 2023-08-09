# Updated on 20230228
FROM alpine:3.18.3

ARG VERSION

LABEL maintener="Thomas Champagne"
LABEL version=$VERSION

ENV BLOCKLISTS_UPDATE_SCHEDULE 0 2 * * *
ENV CONF_DIR /etc/dnsmasq.d/
ENV SAMPLE_CONF_DIR /etc/dnsmasq.d.samples/
ENV BLOCKLIST_DIR /blocklists/

WORKDIR /app

RUN apk update \
    && apk upgrade \
    && apk --no-cache add dnsmasq tzdata
RUN mkdir -p ${BLOCKLIST_DIR}
RUN mkdir -p ${SAMPLE_CONF_DIR}

COPY dnsmasq.conf /etc/
COPY dns.conf ${SAMPLE_CONF_DIR}
COPY dhcp.conf ${SAMPLE_CONF_DIR}
COPY run.sh .

RUN chmod +x /app/run.sh

VOLUME ${CONF_DIR}

EXPOSE 53/udp 53/tcp

CMD ["/app/run.sh"]
