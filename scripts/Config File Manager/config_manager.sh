#!/bin/bash

verbose=false
list_config=false
check_config=false


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
    echo "CONFIGURATION SUMMARY"
    echo "====================="
    echo "FILE: $(readlink -f "$1")"
    awk '/^[^#]/ {print}' "$1"
    count=$(awk '/^[^#]/ {print}' "$1" | wc -l)
    printf "\nTotal configurions: %s\n", "$count"
}

print_verbose() {
    if [[ $verbose = true ]] ; then
        echo "$*"
    fi
}

while getopts "f:k:v:e:t:o:lchV/*/" opt; do
    case $opt in 
        f) config_file="$OPTARG";;
        k) key="$OPTARG";;
        v) value="$OPTARG";;
        e) environment="$OPTARG";;
        t) template_file="$OPTARG";;
        o) output_file="$OPTARG";;
        l) list_config=true ;;
        c) check_config=true ;;
        h) print_help ; exit 0 ;;
        V) verbose=true;;
        *) print_help ; exit 0 ;;
    esac
done

if [[ $list_config = true ]] ; then
    if [[ -f "$config_file" ]] ; then
        list_config "$config_file"
    else echo "Invalid or no Config file" ; exit 0 ;
    fi
fi