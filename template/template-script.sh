#!/bin/bash

# Based on this script template: 
# https://github.com/ralish/bash-script-template/blob/main/script.sh

# A best practices Bash script template with many useful functions.

# This file sources in the bulk of the functions from the common.sh 
# file which it expects to be in the same directory.

# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
fi

# Only enable these shell behaviours if we're not being sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    set -o errexit      # Exit on most errors (see the manual)
    set -o nounset      # Disallow expansion of unset variables
    set -o pipefail     # Use last non-zero exit code in a pipeline
fi

# Enable errtrace or the error trap handler will not work as expected
set -o errtrace         # Ensure the error trap handler is inherited

#######################################################################

# DESC: Display information about how to use this script
# ARGS: None
# OUTS: None
function print_help() {
    printf "TODO add help for usage of this script\n"
}

# parse long, short and positional arguments that are passed to the script
SHORT_OPTIONS=hfa:b:
LONG_OPTIONS=help,flag,optionA:,optionB:
args=$(getopt --alternative --name template-script --options $SHORT_OPTIONS --long $LONG_OPTIONS -- "$@")
if [[ $? -gt 0 ]]; then
    usage
fi

eval set -- ${args}
while :
do
    case $1 in
        -h | --help)
            print_help
            exit 0
            ;;
        -a | --optionA)
            option_a=$2
            shift 2
            ;;
        -b | --optionB)
            option_b=$2
            shift 2
            ;;

        --) shift; break ;;
        *) >&2 echo "Unsupported option: $1"
            print_help
    esac
done

if [[ $# -eq 0 ]]; then
    print_help
fi

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parse_params() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -q | --quiet)
                quiet=true
                shift
                ;;
            -h | --help)
                print_help
                exit 0
                ;;
            *)
                positional_args+=("$1")
                shift
                ;;
        esac
    done
    set -- "${positional_args[@]}"

}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    trap script_trap_err ERR
    trap script_trap_exit EXIT

    script_init "$@"
    parse_params "$@"
    cron_init
    colour_init
    #lock_init system
}

# shellcheck source=source.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Invoke main with args if not sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    main "$@"
fi

# vim: syntax=sh cc=80 tw=79 ts=4 sw=4 sts=4 et sr