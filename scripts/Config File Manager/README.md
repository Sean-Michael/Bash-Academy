# Exercise 3: Configuration File Manager

**Scenario**: You're managing application configurations across multiple environments (dev, staging, prod). You need a script that can update configuration values, validate settings, and generate environment-specific config files from templates.

## Your task: Write a script called `config_manager.sh` that:

### Core Requirements:
- Uses `getopts` to handle command-line options
- Accepts these flags:
  - `-f CONFIG_FILE` : Target configuration file (required)
  - `-k KEY` : Configuration key to update
  - `-v VALUE` : New value for the key
  - `-e ENVIRONMENT` : Environment (dev/staging/prod)
  - `-t TEMPLATE_FILE` : Template file to process
  - `-o OUTPUT_FILE` : Output file for processed template
  - `-l` : List all configuration keys and values
  - `-c` : Check/validate configuration format
  - `-h` : Show help message
  - `-V` : Verbose mode

### Expected behavior examples:
```bash
# Update a specific key-value pair
./config_manager.sh -f app.conf -k database.host -v "192.168.1.100"

# Generate config from template for staging environment
./config_manager.sh -t app.conf.template -e staging -o staging_app.conf

# List all configurations
./config_manager.sh -f app.conf -l

# Validate configuration file
./config_manager.sh -f app.conf -c
```

### Configuration File Format:
Your script should handle standard key=value format:
```
# Database Configuration
database.host=localhost
database.port=5432
database.name=myapp
database.user=appuser

# Application Settings  
app.debug=false
app.max_connections=100
app.timeout=30

# Cache Configuration
cache.enabled=true
cache.ttl=3600
```

### Template File Format:
Templates use `{{VARIABLE}}` placeholders:
```
# Generated config for {{ENVIRONMENT}} environment
database.host={{DB_HOST}}
database.port={{DB_PORT}}
app.debug={{DEBUG_MODE}}
app.log_level={{LOG_LEVEL}}
```

### Key syntax patterns you'll need:

#### Variable substitution with validation:
```bash
config_file="${config_file:?ERROR: Configuration file is required}"
key="${key:?ERROR: Key is required when updating}"
```

#### Reading and parsing key=value files:
```bash
# Extract value for a specific key
awk -F'=' -v key="$search_key" '$1 == key {print $2}' "$config_file"

# Get all keys (ignore comments and empty lines)
grep -v '^#' "$config_file" | grep -v '^$' | cut -d'=' -f1
```

#### Updating configuration values:
```bash
# Update existing key or add new one
sed -i "s/^${key}=.*/${key}=${value}/" "$config_file"
```

#### Template processing:
```bash
# Replace template variables
sed "s/{{ENVIRONMENT}}/${environment}/g" "$template_file"
```

#### Configuration validation:
```bash
# Check for required keys
required_keys=("database.host" "database.port" "app.debug")
for req_key in "${required_keys[@]}"; do
    # Validation logic here
done
```

## Sample Output:

### List mode (`-l`):
```
CONFIGURATION SUMMARY
====================
database.host=localhost
database.port=5432  
database.name=myapp
app.debug=false
app.max_connections=100

Total configurations: 5
```

### Update mode:
```
Updating configuration...
Key: database.host
Old value: localhost
New value: 192.168.1.100
Configuration updated successfully.
```

### Validation mode (`-c`):
```
CONFIGURATION VALIDATION
=======================
✓ database.host: localhost
✓ database.port: 5432 (valid port range)
✗ app.max_connections: invalid_value (must be numeric)

Validation failed: 1 error found
```

### Template processing:
```
Processing template: app.conf.template
Environment: staging
Output file: staging_app.conf
Template processed successfully.
```

## Environment Variables for Templates:
Your script should support these environment-specific defaults:

**Development:**
- DB_HOST=localhost
- DB_PORT=5432
- DEBUG_MODE=true
- LOG_LEVEL=debug

**Staging:**
- DB_HOST=staging-db.company.com
- DB_PORT=5432
- DEBUG_MODE=false
- LOG_LEVEL=info

**Production:**
- DB_HOST=prod-db.company.com
- DB_PORT=5432
- DEBUG_MODE=false
- LOG_LEVEL=error

## Test Files to Create:

### `app.conf`:
```
# Application Configuration
database.host=localhost
database.port=5432
database.name=myapp
database.user=appuser
app.debug=true
app.max_connections=50
app.timeout=30
cache.enabled=true
cache.ttl=3600
```

### `app.conf.template`:
```
# {{ENVIRONMENT}} Environment Configuration
database.host={{DB_HOST}}
database.port={{DB_PORT}}
database.name=myapp_{{ENVIRONMENT}}
app.debug={{DEBUG_MODE}}
app.log_level={{LOG_LEVEL}}
app.max_connections=100
```

## Bonus Challenges (try after basic version works):
1. Support nested configuration keys (e.g., `database.connection.timeout`)
2. Add backup functionality (create `.bak` files before changes)
3. Support different config formats (JSON, YAML detection)
4. Add configuration diff mode to compare two config files
5. Support configuration encryption/decryption for sensitive values

## Testing Commands:
```bash
# Test all functionality
./config_manager.sh -f app.conf -l
./config_manager.sh -f app.conf -k database.host -v "new-host.com"
./config_manager.sh -f app.conf -c
./config_manager.sh -t app.conf.template -e staging -o staging.conf
```

**Focus areas for this exercise:**
- `sed` for in-place file editing
- `awk` for structured text processing  
- Complex variable substitution patterns
- Array handling for validation
- File I/O operations
- String manipulation and regex patterns

This exercise builds on your previous work while introducing more advanced text processing - essential for DevOps automation!