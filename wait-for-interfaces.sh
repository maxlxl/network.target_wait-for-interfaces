#!/bin/bash

TIMEOUT=300
INTERFACES=("ib0")

for IFACE in "${INTERFACES[@]}"; do
    COUNTER=0
    while ! nmcli device show "$IFACE" | grep -q "(connected)"; do
        sleep 1
        COUNTER=$((COUNTER + 1))
        if [ "$COUNTER" -ge "$TIMEOUT" ]; then
            echo "Interface $IFACE did not come online within timeout"
            exit 1
        fi
    done
done

exit 0
