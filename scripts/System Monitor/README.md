# Exercise 2: System Monitor Script

**Scenario**: You need to create a system monitoring script that checks disk usage, memory usage, and running processes. This script should accept command-line options and generate alerts when thresholds are exceeded.

## Your task: Write a script called `system_monitor.sh` that:

### Core Requirements:
- Uses `getopts` to handle command-line options
- Accepts these flags:
  - `-d THRESHOLD` : Disk usage threshold (default: 80)
  - `-m THRESHOLD` : Memory usage threshold (default: 90) 
  - `-p PROCESS_NAME` : Check if specific process is running
  - `-h` : Show help message
  - `-v` : Verbose output
- Outputs warnings when thresholds are exceeded
- Returns appropriate exit codes (0 for success, 1 for warnings, 2 for errors)

### Expected behavior examples:
```bash
./system_monitor.sh -d 75 -m 85 -v
./system_monitor.sh -p apache2 -d 90
./system_monitor.sh -h
```

### Key syntax patterns you'll need:

#### getopts pattern:
```bash
while getopts "d:m:p:hv" opt; do
    case $opt in
        d) disk_threshold="$OPTARG" ;;
        # ... other cases
    esac
done
```

#### Getting disk usage:
```bash
df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
```

#### Getting memory usage:
```bash
free | awk 'NR==2{printf "%.0f", $3*100/$2}'
```

#### Process checking:
```bash
pgrep -x "$process_name" > /dev/null
```

## Sample Output:

### Normal run:
```
SYSTEM MONITOR REPORT
====================
Disk Usage: 45% (OK - threshold: 80%)
Memory Usage: 67% (OK - threshold: 90%)
All systems normal.
```

### With warnings:
```
SYSTEM MONITOR REPORT
 ====================
Disk Usage: 85% (WARNING - exceeds threshold: 80%)
Memory Usage: 67% (OK - threshold: 90%)
Process 'apache2': RUNNING

WARNING: System thresholds exceeded!
```

### Verbose mode adds:
```
[VERBOSE] Checking disk usage...
[VERBOSE] Current disk usage: 45%
[VERBOSE] Disk threshold: 80%
[VERBOSE] Checking memory usage...
...
```

## Bonus Challenges (try after basic version works):
1. Add `-f LOGFILE` option to write output to file
2. Add timestamp to output
3. Support checking multiple processes with `-p proc1,proc2,proc3`
4. Add CPU usage monitoring

## Testing your script:
Create test cases with different flag combinations and verify exit codes:
```bash
./system_monitor.sh -d 10  # Should trigger disk warning
echo $?                    # Should print 1
```

**Focus areas for this exercise:**
- `getopts` argument parsing
- Variable substitution with defaults
- Conditional logic and exit codes
- Command substitution and piping
- Error handling