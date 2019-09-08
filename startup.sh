#!/bin/ash

set -e

CHOWN=$(/usr/bin/which chown)
SQUID=$(/usr/bin/which squid)

# Set permissions correctly on the Squid cache when it's loaded as a volume
echo "=========== fixing cache dir permissions"
"$CHOWN" -R squid:squid /var/cache/squid

echo "=========== Check config location"
FILE=/etc/squid/squid.conf
if [ -f "$FILE" ]; then
    echo "=========== Config is there, do nothing"
else 
    echo "=========== Config not found, assuming defaults"
    cp /etc/squid.dist/* /etc/squid
fi

# Prepare the cache using Squid.
echo "=========== Initialize cache"
"$SQUID" -z

echo "=========== Sleep a bit"
# Give the Squid cache some time to rebuild.
sleep 5

# Launch squid
echo "Starting Squid..."
exec "$SQUID" -NYCd 1
