#!/bin/bash -e

# print basic system resources usage

ROOTFS=$(df --output='pcent' / | awk 'NR==2 { gsub("%",""); print }')

LA1=$(cut -f 1 -d ' ' /proc/loadavg)
CORES=$(awk -F ':' '/cpu cores/ {print $2; exit}' /proc/cpuinfo)
LA1_CORE=$(awk "BEGIN { printf(\"%.2f\", $LA1/$CORES) }")

MEM_TOTAL=$(awk '/MemTotal/     {print $2}' /proc/meminfo)
MEM_AVAIL=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
MEM_USED=$(awk "BEGIN { printf(\"%.0f\", (1 - $MEM_AVAIL/$MEM_TOTAL)*100) }")

echo "$(ping -w 1 -qc 1 8.8.8.8 >/dev/null && echo UP || echo DOWN)     L $LA1_CORE     M $MEM_USED     F $ROOTFS"
