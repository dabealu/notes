#### QEMU-KVM, tested on debian 8  

install qemu-kvm:
```
apt-get -y install qemu-kvm
```

create vm image with size of 50 Gb:
```
qemu-img create -f qcow2 vm1.qcow 50G
```
  
run vm (first time with installation cd inserted):
```
kvm -m 1024 -cpu host -smp cores=2 -name vm1 -cdrom ISO/debian-8.5.0-amd64-netinst.iso -boot once=d -drive file=vm1.qcow,if=virtio -vga qxl -spice port=5900,addr=0.0.0.0,disable-ticketing
```
  
some keys:  
-smp - vm cpu allocation  
-cdrom - attach cd  
-boot once=d - boot from cd (d)  
-boot menu=on,splash-time=10000 - enable boot menu, show 10000ms  
-spice - enable spice server on 0.0.0.0:5900 (without auth, use password=secret for passworded access)  
  
create bridge interface:
```
apt-get install bridge-utils
brctl addbr br0
```

in /etc/network/interfaces use old eth0 config for br0, plus bridge stuff:
```
auto br0
iface br0 inet static
  bridge_ports eth0
  bridge_stp off
  bridge_fd 0
  bridge_maxwait 0
    address 192.168.1.202
    netmask 255.255.255.0
    gateway 192.168.1.1
```
  
to generate uniq mac address for vm we use qemu-mac-hasher.py (see archlinux qemu wiki):
```
#!/usr/bin/env python
import sys
import zlib
if len(sys.argv) != 2:
    print("usage: %s <VM Name>" % sys.argv[0])
    sys.exit(1)
crc = zlib.crc32(sys.argv[1].encode("utf-8")) & 0xffffffff
crc = str(hex(crc))[2:]
print("52:54:%s%s:%s%s:%s%s:%s%s" % tuple(crc))
```
  
edit /etc/qemu-ifdown script (in debian 8, ifup already ok, but ifdown is empty):  
```
#!/bin/bash
ip link set $1 down
brctl delif br0 $1
ip link delete dev $1
```

we ready to start vm (press F12 to enter boot menu and select cdrom to install OS):  
```
vm_name="vm1" && kvm -m 1024 -cpu host -name ${vm_name} \
  -cdrom ISO/debian-8.5.0-amd64-netinst.iso \
  -boot menu=on,splash-time=10000 \
  -net nic,model=virtio,macaddr=$(qemu-mac-hasher.py "${vm_name}") \
  -net tap,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown,vhost=on \
  -drive file=${vm_name}.qcow,if=virtio \
  -vga qxl -spice port=5900,addr=0.0.0.0,password=p4s$w0rd
```
  
spice clients to connect to vms:  
spicy - on debian/ubuntu desktop (apt-get install spice-client-gtk)  
spice-html5 - web client (https://github.com/SPICE/spice-html5)  
  
  
links:  
https://wiki.archlinux.org/index.php/QEMU  
http://www.spice-space.org/  
https://wiki.archlinux.org/index.php/QEMU#Networking  
https://help.ubuntu.com/community/KVM/Networking  
