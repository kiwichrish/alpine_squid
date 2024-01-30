#!/bin/ash
set -e

# find chown and squid, just in case
CHOWN=$(/usr/bin/which chown)
SQUID=$(/usr/bin/which squid)

# Set permissions correctly on the Squid cache and log when loaded as a volumes
echo "=========== fixing cache dir permissions"
"$CHOWN" -R squid:squid /squid
"$CHOWN" -R squid:squid /var/log/squid

echo "=========== Check config location"
FILE=/etc/squid/squid.conf
if [ -f "$FILE" ]; then
    echo "=========== Config is there, do nothing"
else 
    echo "=========== Config not found, assuming defaults"
    cp /etc/squid.dist/* /etc/squid
fi

# Checking for PID file..  
# Had an issue with squid.pid being pre-existing if container was restarted sometimes.  Odd.
if [ -f "/var/run/squid.pid" ]; then
    echo "============ PID file exists, clearing before starting squid"
    rm /var/run/squid.pid
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
