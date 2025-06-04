#!/bin/bash

logfile="${1:-/var/log/apache2/access.log}"

echo "Top 5 IPs with failed logins:"
awk '$9 == 401 {print $1}' "$logfile" | sort | uniq -c | sort -nr | head -5
