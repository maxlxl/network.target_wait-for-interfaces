# network.target_wait-for-interfaces
**Description**:  
This service solves the issue of the NFS mounts being mounted earlier than their required network interface becoming connected.  
The issue occurs due to the NetworkManager-wait-online.target to get activated as soon as the first interface changing to the connected state. However it could be the case, that this interface is not the interface used by the NFS mountpoints. Sometimes the ib0 interface takes quite a lot of time to get connected and becoming a race condition with the nfs mounts.  

**Solution**:  
The fix is to implement a service which specifically checks for the required interface and delays the network.target which then delays the mounting of NFS mountpoints.  

## Implementation
`wait-for-interfaces.sh` -> `/usr/local/bin/wait-for-interfaces.sh`  
`wait-for-interfaces.service` -> `/etc/systemd/system/wait-for-interfaces.service`  
`systemctl enable wait-for-interfaces.service`

make sure to  
`chmod +x /usr/local/bin/wait-for-interfaces.sh`
