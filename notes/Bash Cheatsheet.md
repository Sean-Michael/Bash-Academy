# Variable Substitution Patterns

```bash
${var}              # Basic substitution
${var:-default}     # Use default if var is unset
${var:=default}     # Set var to default if unset
${#var}            # Length of var
${var#pattern}     # Remove shortest match from beginning
${var%pattern}     # Remove shortest match from end
```

# Command Line Args

```bash
$0  # Script name
$1, $2, $3  # Positional arguments
$#  # Number of arguments
$@  # All arguments as separate words
$*  # All arguments as single word
```

# Common sed patterns

```bash
sed 'sold/new/g'           # Replace all occurrences
sed -n '5,10p'              # Print lines 5-10
sed '/pattern/d'            # Delete lines matching pattern
```

# Common awk patterns

```bash
awk '{print $1}'            # Print first field
awk -F: '{print $1}'        # Use colon as field separator
awk '/pattern/ {print $0}'  # Print lines matching pattern
```