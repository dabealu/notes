#!/bin/sh -e

ROOTFS=$( df --output='pcent' / | awk 'NR==2 {gsub("%",""); print}' )
LA1_CORE=$( awk '/cpu cores/ {c=$4} $1 ~ /^[0-9]+\.[0-9]+/ {l=$1} END {printf("%.1f", l/c)}' /proc/cpuinfo /proc/loadavg )
MEM_USED=$( awk '$1 ~ /MemTotal/ {t=$2} $1 ~ /MemAvailable/ {a=$2} END {printf("%.0f", (1-a/t)*100 )}' /proc/meminfo )
PING=$( ping -w 1 -qc 1 1.1.1.1 >/dev/null && echo ok || echo fail )

DATE=$( date "+%b %d.%m.%Y %H:%M:%S" )
BAT=$( P='/sys/class/power_supply/BAT0/'; test -d $P && awk '{s[NR]=$1} END {printf("%s%% %s", s[1], s[2])}' $P/capacity $P/status || : )
VOL=$( amixer -D pulse get Master | awk -F '[][]' '/%/ {print $2; exit}' )
KB_LAYOUT=$( swaymsg -p -t get_inputs | awk '/Active Keyboard Layout/ {printf("%.2s", toupper($4)); exit}' )

echo "ping $PING  la1 $LA1_CORE  mem $MEM_USED  rootfs $ROOTFS | <span foreground=\"#66cc00\">bat $BAT</span> | <span foreground=\"#ff93fd\">vol $VOL</span> | <span foreground=\"#4cffff\">$KB_LAYOUT</span> | $DATE"


