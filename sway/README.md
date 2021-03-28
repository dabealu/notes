## swaywm

### packages and config
install on ubuntu server as a base image:
```
# install packages
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  curl \
  git \
  unzip \
  sway \
  swaylock \
  swayidle \
  xwayland \
  dmenu \
  libnotify-bin \
  dunst \
  pulseaudio \
  pulseaudio-module-bluetooth \
  alsa-utils \
  pavucontrol \
  bluetooth \
  bluez \
  bluez-tools \
  blueman \
  wl-clipboard \
  grim \
  slurp \
  wpasupplicant

# extra packages
sudo apt-get install -y --no-install-recommends \
  thunar \
  gnome-terminal \
  wdisplays \
  lxappearance

# copy configs
mkdir -p ~/.config/sway
cp * ~/.config/sway
```
NOTE: `xwayland` may require restart

run sway from terminal: `sway`


### screen resolution
list outputs: `swaymsg -t get_outputs`, and add to sway config:
```
output HDMI-A-1 resolution 1920x1080 position 0,0
```
position in pixels, so second monitor placed to the right will have `1920,0`.


### appearance
some appearance settings are avaiable through `lxappearance`


### notifications
default dunst config: `/etc/xdg/dunst/dunstrc`
user specific customizations: `~/.config/dunst/dunstrc`


### timezone
```
sudo timedatectl set-timezone Asia/Singapore
```


### performance
enable `performance` CPU scaling governor:
```
sudo apt-get install -y cpufrequtils
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
# check
cat /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor
```

set `mitigations=off` kernel parameter to disable hardware vulnerability mitigations.
**warning:** this is potentially dangerous, but can significantly increase CPU performance.


### passwordless sudo
passwordless sudo:
```
username ALL = (ALL) NOPASSWD: ALL
```


### network and wifi
use netplan to configure network without `NetworkManager`.

list interfaces:
```
networkctl
```

create config, i.e.:
```
# /etc/netplan/config.yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s31f6:
            dhcp4: true
    wifis:
        wlp2s0:
            dhcp4: true
            nameservers:
                addresses: [1.1.1.1, 8.8.8.8]
            access-points:
                "network_ssid_name":
                    password: "**********"
            
```

apply config:
```
sudo netplan apply
```

to bring interface up/down:
```
ip link set wlp2s0 up
ip link set wlp2s0 down
```

show settings:
```
netplan get all
```

more configuration examples: https://netplan.io/examples/
also check FAQ and troubleshooting for more info.

install and run `wavemon` TUI to list wifi networks:
```
sudo apt install -y wavemon

wavemon
```

or use `kismet` - advanced wireless scanner/sniffer with web interface:
https://www.kismetwireless.net/docs/readme_group.html


### additional packages
```
sudo apt install -y --no-install-recommends \
  numix-icon-theme \
  numix-blue-gtk-theme \
  firefox \
  audacious \
  evince \
  ubuntu-restricted-extras \
  ttf-ubuntu-font-family
```


### touchpad gestures
libinput: https://wayland.freedesktop.org/libinput/doc/latest/gestures.html
