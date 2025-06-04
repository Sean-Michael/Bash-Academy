#!/bin/bash

help=false
verbose=false

while getopts "d:m:p:hv" opt; do 
    case $opt in
        d) disk_threshold="$OPTARG" ;;
        m) mem_threshold="$OPTARG" ;;
        p) proc_name="$OPTARG" ;;
        h) help=true ;;
        v) verbose=true ;;
    esac
done

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')    
