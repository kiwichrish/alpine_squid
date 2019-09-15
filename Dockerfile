# Squid container
# Chris H <chris@trash.co.nz>

FROM alpine:latest

EXPOSE 3128/tcp

RUN apk add --update --no-cache squid tzdata \
    && mkdir /etc/squid.dist \
    && mv /etc/squid/* /etc/squid.dist/

ADD squid.conf /etc/squid.dist/squid.conf
ADD startup.sh /startup.sh

# Simple health Check
HEALTHCHECK CMD netstat -an | grep 3128 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

VOLUME /squid
VOLUME /etc/squid
VOLUME /var/log/squid

ENTRYPOINT ["/startup.sh"]
