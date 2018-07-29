#!/bin/bash -e

# print basic system resources usage

ROOTFS=$(df --output='pcent' / | awk 'NR==2 {gsub("%",""); print}')
LA1_CORE=$(awk '/cpu cores/ {c=$4} $1 ~ /^[0-9]+\.[0-9]+/ {l=$1} END {printf("%.2f", l/c)}' /proc/cpuinfo /proc/loadavg)
MEM_USED=$(awk '$1 ~ /MemTotal/ {t=$2} $1 ~ /MemAvailable/ {a=$2} END {printf("%.0f", (1-a/t)*100 )}' /proc/meminfo)
PING_STATE=$(ping -w 1 -qc 1 8.8.8.8 >/dev/null && echo UP || echo DOWN)

echo "$PING_STATE     L $LA1_CORE     M $MEM_USED     F $ROOTFS"

