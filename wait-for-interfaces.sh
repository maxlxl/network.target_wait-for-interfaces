#!/bin/bash

TIMEOUT=300
INTERFACES=("ib0")

for IFACE in "${INTERFACES[@]}"; do
    COUNTER=0
    while ! nmcli --get-values GENERAL.STATE device show "$IFACE" | grep -q "(connected)"; do
        # Print debugging info to syslog
        echo -n "Waiting for interface $IFACE to come online:"
        nmcli --get-values GENERAL.STATE device show "$IFACE"
        sleep 1
        COUNTER=$((COUNTER + 1))
        if [ "$COUNTER" -ge "$TIMEOUT" ]; then
            echo "ERROR: Interface $IFACE did not come online within timeout=$TIMEOUT"
            exit 1
        fi
    done
done

exit 0
