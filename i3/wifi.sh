#!/bin/bash -e

###
# configure wifi interface via systemd-networkd and wpa_supplicant.
# NetworkManager must be stopped (and disabled).
# run with root privileges.
# additional SSIDs can be added manually by creating
# 'network' blocks in /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf
###

# get names of wlan interfaces
WI=$(networkctl | awk '/wlan/ {print $2}')
if [[ -z "$WI" ]]; then
  echo "There's no wlan interfaces, exiting"
  exit 0
fi

# create array of interfaces
declare -a WI_LIST
NUM=1
for IF in $WI; do
  WI_LIST[$NUM]=$IF
  echo "$NUM : $IF"
  NUM=$(($NUM+1))
done

# if there are more than one wlan interface, ask which to configure
if [[ "${#WI_LIST}" -gt "1" ]]; then
  echo -n "enter interface number: "
  read IF_NUM
  IF_NAME=${WI_LIST[$IF_NUM]}
else
  IF_NAME=${WI_LIST[1]}
fi

# get credentials for wifi connection
echo -n "enter SSID: "
read SSID
echo -n "enter '$SSID' password: "
read PASSWORD

# systemd networkd unit
echo "creating networkd systemd unit: /etc/systemd/network/wlan-$IF_NAME.network"
cat <<EOF > /etc/systemd/network/wlan-$IF_NAME.network
[Match]
Name=$IF_NAME

[Network]
DHCP=ipv4
## static config
#DNS=8.8.8.8
#Address=192.168.1.100/24
#Gateway=192.168.1.1

[DHCP]
RouteMetric=20
EOF

# wpa_supplicant config
echo "creating wpa_supplicant config: /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf"
cat <<EOF > /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=sudo
update_config=1
eapol_version=1
ap_scan=1
fast_reauth=1
EOF

# add network credentials to config, multiple 'network' directives are allowed (one per ssid)
wpa_passphrase "$SSID" "$PASSWORD" >> /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf
chmod 0600 /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf

# systemd wpa_supplicant unit
echo "creating wpa_supplicant systemd unit: /etc/systemd/system/wpa_supplicant.service"
cat <<EOF > /etc/systemd/system/wpa_supplicant.service
[Unit]
Description=WPA supplicant
Before=network.target

[Service]
User=root
ExecStart=/sbin/wpa_supplicant -i $IF_NAME -c /etc/wpa_supplicant/wpa_supplicant-$IF_NAME.conf

[Install]
WantedBy=multi-user.target
EOF

# start services
systemctl daemon-reload
systemctl restart systemd-networkd wpa_supplicant

