#!/bin/bash
# logger.sh



# Farbcodes definieren
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"  # Reset für normale Ausgabe

LOG_FILE=$(pwd)/firmware-builder.log


log_to_file() {
    local message="$1"
    echo -e "$message" | tee -a "$LOG_FILE"
}

log() {
    local status="$1"
    shift
    local message="$*"
    
    case "$status" in
        info)
            local message="${GREEN}[INFO] ${RESET}$1"
            log_to_file "$message"
            ;;
        err)
            local message="${RED}[ERROR] ${RESET}$1"
            log_to_file "$message"
            ;;
        succ)
            local message="${CYAN}[SUCCESS] ${RESET}$1"
            log_to_file "$message"
            ;;
        warn)
            local message="${YELLOW}[WARN] ${RESET}$1"
            log_to_file "$message"
            ;;
        dbg)
            local message="${BLUE}[DEBUG] ${RESET}$1"
            log_to_file "$message"
            ;;
        *)
            local message="${BLUE}[UNKNOWN] ${RESET}$1"
            log_to_file "$message"
            ;;
    esac
}
