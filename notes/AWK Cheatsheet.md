# AWK Cheatsheet

## Basic Structure
```bash
awk 'CONDITION {ACTION}' filename
command | awk 'CONDITION {ACTION}'
```

## Built-in Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NR` | Number of Records (current line number) | `NR==5` (line 5) |
| `NF` | Number of Fields (in current line) | `NF==3` (3 fields) |
| `$0` | Entire current line | `{print $0}` |
| `$1, $2, $3...` | Field 1, 2, 3, etc. | `{print $1}` |
| `FS` | Field Separator (default: whitespace) | `FS=":"` |

## Field Operations

### Basic Field Printing
```bash
awk '{print $1}'              # Print 1st field of every line
awk '{print $1, $3}'          # Print 1st and 3rd fields (space separated)
awk '{print $1 ":" $3}'       # Print with custom separator
awk '{print $NF}'             # Print last field
awk '{print $(NF-1)}'         # Print second-to-last field
```

### Field Separators
```bash
awk -F: '{print $1}'          # Use colon as separator
awk -F',' '{print $2}'        # Use comma as separator (CSV)
awk -F'[ \t]+' '{print $1}'   # Multiple spaces/tabs as separator
awk 'BEGIN{FS=":"} {print $1}' # Set separator in BEGIN block
```

## Conditional Operations

### Row-based Conditions
```bash
awk 'NR==5 {print}'           # Print only line 5
awk 'NR>=5 && NR<=10 {print}' # Print lines 5-10
awk 'NR%2==0 {print}'         # Print even-numbered lines
awk 'END {print NR}'          # Print total number of lines
```

### Field-based Conditions
```bash
awk '$3 > 100 {print $1}'     # Print 1st field where 3rd field > 100
awk '$2 == "error" {print}'   # Print lines where 2nd field equals "error"
awk '$1 != "admin" {print}'   # Print lines where 1st field is not "admin"
awk 'length($1) > 5 {print}'  # Print lines where 1st field > 5 characters
```

### Pattern Matching
```bash
awk '/error/ {print}'         # Print lines containing "error"
awk '/^[0-9]/ {print}'        # Print lines starting with digit
awk '$1 ~ /^192\.168/ {print}' # Print if 1st field matches IP pattern
awk '$0 !~ /debug/ {print}'   # Print lines NOT containing "debug"
```

## Mathematical Operations

### Basic Calculations
```bash
awk '{print $1 + $2}'         # Add fields 1 and 2
awk '{print $2 * 1.5}'        # Multiply field 2 by 1.5
awk '{sum += $3} END {print sum}' # Sum all values in 3rd field
awk '{avg += $2; count++} END {print avg/count}' # Calculate average
```

### Counting and Statistics
```bash
awk '{count[$1]++} END {for (i in count) print i, count[i]}' # Count occurrences
awk '$3 > max {max = $3} END {print max}' # Find maximum value
awk 'BEGIN{min=999999} $2 < min {min = $2} END {print min}' # Find minimum
```

## String Operations

### String Functions
```bash
awk '{print length($1)}'      # Length of 1st field
awk '{print toupper($1)}'     # Convert to uppercase
awk '{print tolower($1)}'     # Convert to lowercase
awk '{print substr($1, 2, 3)}' # Substring: start at pos 2, length 3
```

### String Manipulation
```bash
awk '{gsub(/old/, "new", $0); print}' # Replace all "old" with "new"
awk '{sub(/^[ \t]+/, "", $1); print}' # Remove leading whitespace from field 1
awk '{print $1 "_suffix"}'    # Append text to field
```

## Control Structures

### BEGIN and END Blocks
```bash
awk 'BEGIN {print "Starting..."} {print $1} END {print "Done."}' 
awk 'BEGIN {FS=":"} {print $1}' # Set field separator before processing
awk 'END {print "Total lines:", NR}' # Print summary at end
```

### Conditionals and Loops
```bash
awk '{if ($3 > 100) print $1; else print $2}' # If-else
awk '{for (i=1; i<=NF; i++) print $i}'        # Loop through fields
awk '{while (getline > 0) count++} END {print count}' # While loop
```

## DevOPS Common Patterns

### Log Analysis
```bash
# Count HTTP status codes
awk '{count[$9]++} END {for (code in count) print code, count[code]}' access.log

# Extract IPs with failed logins (401 errors)
awk '$9 == 401 {print $1}' access.log

# Show requests per hour
awk '{print substr($4, 2, 11)}' access.log | sort | uniq -c
```

### System Monitoring
```bash
# Memory usage percentage
free | awk 'NR==2{printf "%.0f", $3*100/$2}'

# Disk usage without % symbol
df -h | awk 'NR>1 {gsub(/%/, "", $5); print $1, $5}'

# Process CPU usage
ps aux | awk '$3 > 1.0 {print $2, $3, $11}' # PIDs using >1% CPU
```

### File Processing
```bash
# CSV processing
awk -F',' '{print $1 "," $3}' data.csv # Extract columns 1 and 3

# Configuration files
awk -F'=' '/^[^#]/ {print $1}' config.conf # Get config keys (skip comments)

# Network configuration
awk '/inet / {print $2}' # Extract IP addresses from ifconfig output
```

## Advanced Techniques

### Arrays and Associative Arrays
```bash
# Store data in array
awk '{arr[NR] = $1} END {for (i=1; i<=NR; i++) print arr[i]}'

# Associative array (like Python dict)
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}'
```

### Multiple Field Separators
```bash
awk -F'[,:]' '{print $2}' # Use comma OR colon as separator
awk -F'[ \t,]+' '{print $1}' # Multiple separators: space, tab, comma
```

### Output Formatting
```bash
awk '{printf "%-10s %5d\n", $1, $2}' # Formatted output (left-align, width)
awk 'BEGIN{print "Name", "Score"} {printf "%-8s %3d\n", $1, $2}' # Table format
```

## Quick Reference Examples

```bash
# Print specific lines
awk 'NR==5,NR==10 {print}'   # Lines 5 through 10
awk 'FNR==1 {print FILENAME ":" $0}' # First line of each file with filename

# Field manipulation
awk '{$1=""; print $0}'      # Remove first field, print rest
awk '{print NF, $0}'         # Print field count and line
awk 'NF > 3 {print}'         # Print lines with more than 3 fields

# Complex conditions
awk '$1~/^[0-9]+$/ && $2=="ERROR" {print $3}' # Numeric 1st field AND 2nd field is "ERROR"
```

## Common Gotchas

1. **Field numbering starts at 1**, not 0 (unlike most programming languages)
2. **`$0` is the entire line**, not empty
3. **String comparison**: Use `==` for exact match, `~` for regex match
4. **Default separator**: Any whitespace (spaces, tabs), not just single space
5. **Variables are global** by default in AWK
6. **Print without arguments** prints the entire line (`$0`)