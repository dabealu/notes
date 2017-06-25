##### initial installation and config
install:
```
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
sudo apt-get update
sudo apt-get install lxd -y 
```
**NOTE:** relogin after lxd installation to be allowed use `lxc` command without sudo.  
  
create network (or use interactive `lxd init`):
```
# create bridge
lxc network create lxdbr0 ipv6.address=none ipv4.address=10.10.10.1/24 ipv4.nat=true
# use this bridge in default profile
lxc network attach-profile lxdbr0 default eth0
# if "error: device already exists" occured, first detach profile
lxc network detach-profile lxdbr0 default eth0
```
