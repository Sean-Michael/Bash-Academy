#!/bin/bash

verbose=false
list_mode=false
check_mode=false


print_help() {
    cat << EOF
This utility allows for updating configuration values, validate settings,
and generate environment-specific conig friles from templates. 

The following options are accepted:
    -f CONFIG_FILE : Target configuration file (required)
    -k KEY : Configuration key to update
    -v VALUE : New value for the key
    -e ENVIRONMENT : Environment (dev/staging/prod)
    -t TEMPLATE_FILE : Template file to process
    -o OUTPUT_FILE : Output file for processed template
    -l : List all configuration keys and values
    -c : Check/validate configuration format
    -h : Show help message
    -V : Verbose mode
EOF
}

list_config() {
    print_verbose "list_config()"
    print_verbose "FILE: $(readlink -f "$1")"
    echo "CONFIGURATION SUMMARY"
    echo "====================="
    awk '/^[^#]/ && NF > 0 && /=/ {print}' "$1"
    count=$(awk '/^[^#]/ && NF > 0 && /=/ {print}' "$1" | wc -l)
    printf "\nTotal configurions: %s\n" "$count"
}

update_config() {
    local config="${1:?ERROR: Config file required}"
    local search_key="${2:?ERROR: Search Key Required}"
    local new_value="${3:?ERROR: New Value required}"
    local old_value
    
    print_verbose "update_config ()"
    print_verbose "FILE: $1 KEY: $2 VAL: $3"

    echo "Updating configuration:"
    echo "Key: $search_key"
    print_verbose "Searching for existing key in $config"

    old_value=$(awk -F'=' -v key="$search_key" '$1 == key {print $2}' "$config")
    if [[ -n "$old_value" ]] ; then 
        echo "Old value: $old_value"
        echo "New value: $new_value"
        sed -i "s/^${search_key}=.*/${search_key}=${new_value}/" "$config"
        print_verbose "Updating existing key"
    else 
        print_verbose "Key not found, adding new entry"
        local entry="$search_key=$new_value"
        echo "$entry" >> "$config"
        print_verbose "Created new entry: $entry"
    fi
    echo "Configuration updated successfully."
}

load_env_config () {
    env_file="configs/$environment.env"
    declare -gA config

    [[ -f "$env_file" ]] || { echo "Environment file not found for: $environment"; exit 1; }

    while IFS='=' read -r key value ; do
        [[ "$key" =~ ^[^#]*$ && -n "$key" ]] && config["$key"]="$value"
    done < "$env_file"

    for key in "${!config[@]}"; do
        print_verbose "$key = ${config[$key]}"
    done
}

template_config () {
    load_env_config

    cp "$template_file" "$output_file"

    [[ -f "$output_file" ]] || { echo "Failed to write to file: $output_file" ; exit 1; }

    for key in "${!config[@]}"; do 
        local value="${config[$key]}"
        print_verbose "Replacing {{$key}} with $value"
        sed -i "s|{{$key}}|$value|g" "$output_file"
    done
}

print_verbose() {
    if [[ $verbose = true ]] ; then
        echo "[VERBOSE] $*"
    fi
}

while getopts "f:k:v:e:t:o:lchV" opt; do
    case $opt in 
        f) config_file="$OPTARG";;
        k) key="$OPTARG";;
        v) value="$OPTARG";;
        e) environment="$OPTARG";;
        t) template_file="$OPTARG";;
        o) output_file="$OPTARG";;
        l) list_mode=true ;;
        c) check_mode=true ;;
        h) print_help ; exit 0 ;;
        V) verbose=true;;
        *) print_help ; exit 0 ;;
    esac
done

if [[ $list_mode = true ]] ; then
    [[ -f "$config_file" ]] || { echo "ERROR: config file required" ; exit 1; }
    list_config "$config_file"
fi

if [[ "$key" && "$value" ]] ; then
    [[ -f "$config_file" ]] || { echo "ERROR: config file required" ; exit 1; }
    update_config "$config_file" "$key" "$value"
fi

if [[ "$template_file" && "$environment" && "$output_file" ]] ; then
    [[ -f "$template_file" ]] || { echo "ERROR: template file required" ; exit 1; }
    template_config
fi