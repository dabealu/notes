### i3wm
ubuntu or lubuntu as a more lightweight base:
```
# install packages
sudo apt-get update
sudo apt-get install -y \
  curl \
  unzip \
  i3 \
  i3blocks \
  compton \
  pulseaudio \
  pulseaudio-module-bluetooth \
  pavucontrol \
  bluetooth \
  bluez \
  bluez-tools \
  blueman \
  feh \
  arandr \
  thunar \
  scrot \
  xclip \
  xautolock \
  lxappearance \
  gnome-terminal \
  ristretto \
  gsimplecal

# copy configs
mkdir -p ~/.config/i3
cp * ~/.config/i3/
```
  
appearance settings are avaiable through `lxappearance` and `lightdm-gtk-greeter-settings`  
  
binding app to workspace example:  
- start app  
- start `xprop` and target app window  
- search for `WM_CLASS(STRING)` in the output and copy second field in value, i.e. `Firefox`:  
```
WM_CLASS(STRING) = "Navigator", "Firefox"
```
- edit i3 config to assign app to workspace:  
```
assign [class="Firefox"] $workspace1
```
  
  
### minimalistic installation on top of ubuntu server
install additional packages (on 17.10+):
```
sudo apt install -y \
  xinit \
  numix-icon-theme \
  numix-blue-gtk-theme \
  firefox \
  thunderbird \
  audacious \
  evince \
  ubuntu-restricted-extras \
  ttf-ubuntu-font-family \
  pulseaudio 
```
  
add to `.bashrc` to start `Xorg` after login:
```
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
  exec startx
fi
```

script to configure wifi via `systemd-networkd` and `wpa_supplicant` instead of `NetworkManager`:
```
./wifi.sh
```
