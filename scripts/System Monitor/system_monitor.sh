#!/bin/bash

help=false
verbose=false
warning=false
disk_threshold=80
mem_threshold=90

log_verbose() {
    if [ "$verbose" = "true" ]; then
        echo "[VERBOSE] $*"
    fi
}

while getopts "d:m:p:hv" opt; do 
    case $opt in
        d) disk_threshold="$OPTARG" ;;
        m) mem_threshold="$OPTARG" ;;
        p) proc_name="$OPTARG" ;;
        h) help="true" ;;
        v) verbose="true" ;;
    esac
done

log_verbose "Checking disk usage..."
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
log_verbose "Current disk usage: $disk_usage%"
log_verbose "Disk threshold: $disk_threshold%"

log_verbose "Checking memory usage..."
mem_usage=$(free | awk 'NR==2 {printf "%.0f", $3*100/$2}')
log_verbose "Current memory usage: $mem_usage%"
log_verbose "Memory threshold: $mem_theshold%"

pid=$(pgrep -x "$proc_name" > /dev/null)

echo "SYSTEM MONITOR REPORT"
echo "===================="

if [ "$disk_usage" -gt "$disk_threshold" ]; then
    warning=true
    echo "Disk Usage: $disk_usage% (WARNING - exceeds threshold: $disk_threshold%)"
else
    echo "Disk Usage: $disk_usage% (OK - threshold: $disk_threshold)"
fi

if [ "$mem_usage" -gt "$mem_threshold" ]; then
    warning=true
    echo "Memory Usage: $mem_usage% (WARNING - exceeds threshold: $mem_threshold%)"
else
    echo "Memory Usage: $mem_usage% (OK - threshold: $mem_threshold%)"
fi



if [ $warning==true ]; then
    printf "\nWARNING: System thresholds exceeded!\n"
    exit 1
else 
    printf "\nAll systems normal.\n"
    exit 0
fi