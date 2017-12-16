### i3wm
steps for ubuntu:
```
# install packages
sudo apt-get update
sudo apt-get install -y i3 i3blocks feh arandr thunar scrot lxappearance 
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
