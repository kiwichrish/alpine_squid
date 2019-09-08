# Squid container, for testing stuff.
# Chris H <chris@trash.co.nz>

FROM alpine:latest

EXPOSE 3128/tcp

RUN apk add --update --no-cache squid \
    && mkdir /etc/squid.dist \
    && mv /etc/squid/* /etc/squid.dist/

ADD squid.conf /etc/squid.dist/squid.conf
ADD startup.sh /startup.sh

VOLUME /squid
VOLUME /etc/squid

ENTRYPOINT ["/startup.sh"]
