Simple 2 node keepalived configuration, each node holds 1 VIP as a master and 1 VIP as a backup, in case of failure backup node catch VIP from master.  
/etc/keepalived/keepalived.conf:   
On first node (node0)  
```
vrrp_instance node0_ips {
 state MASTER
 interface enp0s3
 virtual_router_id 1
 priority 150
 advert_int 1

 virtual_ipaddress {
  192.168.1.210
 }
}
vrrp_instance node1_ips {
 state BACKUP
 interface enp0s3
 virtual_router_id 2
 priority 140
 advert_int 1

 virtual_ipaddress {
  192.168.1.220
 }
}
```

On second node (node1):
```
vrrp_instance node0_ips {
 state BACKUP
 interface enp0s3
 virtual_router_id 1
 priority 140
 advert_int 1

 virtual_ipaddress {
  192.168.1.210
 }
}
vrrp_instance node1_ips {
 state MASTER
 interface enp0s3
 virtual_router_id 2
 priority 150
 advert_int 1

 virtual_ipaddress {
  192.168.1.220
 }
}
```
