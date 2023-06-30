# Overview

A small squid proxy...  

For use on small local networks and test / dev setups.  Not really a production cache for larger things but handy to proxy objects for updates / containers on a dev system which is what I'm using it for.

Default size of disk cache is 2GB.

It will initialize the cache folder when it runs if it's not done already and if you run without a mounted volume it will cache into the docker image which will be kinda inefficient, but will work.

Settings are per the defaults for alpine squid:
* Accept traffic from all 'private' subnets and localhost.  (10.0.0.0/8, 100.64.0.0/10, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16, fc00::/7, fe80::/10)
* Allow traffic on common ports and all unregistered ports (443, 80, 21, 70, 210, 280, 488, 591, 777, 1025-65535)
* Only allow https on port 443

Additionally the following changes are in the container:
* logformat set to 'combined' which is more human readable


To override settings, attach a volume at /etc/squid and on first run the image will copy the squid settings it's using to the folder.  Shut down the container, edit the settings per taste and restart.

# Usage:
<pre>
docker run -d --restart always -v /var/cache/squid:/squid -p3128:3128 kiwichrish/alpine_squid
</pre>

## Usage with non-default settings:
<pre>
docker run -d --restart always -v /opt/docker/alpine_squid/etc/squid:/etc/squid -v /var/cache/squid:/squid -p3128:3128 kiwichrish/alpine_squid
</pre>

## Logging

In the same way as you can pick up non default settings by mapping a volume, if you add a volume /var/log/squid you'll get the raw squid logs.

Add a volume option to your run command per:
<pre>
-v /var/log/squid:/var/log/squid
</pre>

# docker-compose

This will get you started using this with docker-compose:
<pre>
version: '3'
services:
  squid:
    image: kiwichrish/alpine_squid
    ports:
      - "3128:3128"
    volumes:
      - "/var/cache/squid:/squid"
      - "/opt/docker/alpine_squid/etc/squid:/etc/squid"
      - "/var/log/squid:/var/log/squid"
    restart: always
</pre>

# Scripts
There are two self explanatory scripts with this repo that are not part of the container..

* build.sh - Builds the container, edit to taste for the tag.
* push.sh  - pushes the container to dockerhub.  Edit that one to taste as well.
