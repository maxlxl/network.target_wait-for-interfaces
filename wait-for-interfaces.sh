#!/bin/bash

TIMEOUT=300
INTERFACES=("ib0")

for IFACE in "${INTERFACES[@]}"; do
    if `nmcli connection show | awk '{print $NF}' | grep -q $IFACE`
    then
        echo "Wait for network interface $IFACE to come online"
        COUNTER=0
        status="`nmcli --get-values GENERAL.STATE device show $IFACE`"
        until echo "$status" | grep -q "(connected)"
        do
            COUNTER=$((COUNTER + 1))
            if [ "$COUNTER" -gt "$TIMEOUT" ]; then
                echo "ERROR: Interface $IFACE did not come online within timeout=$TIMEOUT"
                exit 1
            fi
            sleep 1
	    status="`nmcli --get-values GENERAL.STATE device show $IFACE`"
            echo "Waiting for interface $IFACE to come online: $status"
        done
    else
        echo "Notice: Interface $IFACE not found, available connections are:"
        nmcli connection show 
    fi
done

exit 0
