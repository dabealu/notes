### i3wm
ubuntu or lubuntu as a more lightweight base:
```
# install packages
sudo apt-get update
sudo apt-get install -y \
  i3 \
  i3blocks \
  feh \
  arandr \
  thunar \
  scrot \
  xclip \
  xautolock \
  lxappearance \
  gsimplecal

# copy configs
mkdir -p ~/.config/i3
cp * ~/.config/i3/
```
  
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
  xfce4-terminal \
  pulseaudio 
```
  
`.bashrc` ask to start `Xorg` after login:
```
if ! $(ps -C Xorg >/dev/null); then
  echo -ne "\033[0;32m\n  Start desktop environment ? (y/n) \033[0m"
  read START_DE
  if [[ ! "$START_DE" =~ ^(n|no)$ ]]; then
    startx
  fi
fi
```

wrapper script to configure wifi via `systemd-networkd` and `wpa_supplicant` instead of `NetworkManager`:
```
./wifi.sh
```
