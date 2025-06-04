# Exercise 1: Apache Log Parser

Scenario: You need to extract failed login attempts from an Apache access log and generate a summary report.

## Your task: Write a script called failed_logins.sh that:

- Takes a log file path as the first argument
- Uses a default log path if no argument provided
- Extracts all 401 (Unauthorized) responses
- Counts failures per IP address
- Outputs the top 5 offending IPs

## Sample log data (create a file called access.log):

```log
192.168.1.100 - - [10/Oct/2023:13:55:36 +0000] "POST /login HTTP/1.1" 401 2326
10.0.0.50 - - [10/Oct/2023:13:56:12 +0000] "GET /admin HTTP/1.1" 200 1043
192.168.1.100 - - [10/Oct/2023:13:57:01 +0000] "POST /login HTTP/1.1" 401 2326
203.0.113.45 - - [10/Oct/2023:14:02:15 +0000] "POST /login HTTP/1.1" 401 2326
192.168.1.100 - - [10/Oct/2023:14:05:33 +0000] "POST /login HTTP/1.1" 200 5432
203.0.113.45 - - [10/Oct/2023:14:07:22 +0000] "POST /login HTTP/1.1" 401 2326
```

## Key syntax patterns to use:
```bash
# Variable with default
logfile="${1:-/var/log/apache2/access.log}"
```

# awk field extraction and filtering

```bash
awk '$9 == 401 {print $1}' "$logfile"
```

# Sort and count occurrences

```bash
sort | uniq -c | sort -nr
```

Expected output:

```bash
Top 5 IPs with failed logins:
      2 192.168.1.100
      2 203.0.113.45
```