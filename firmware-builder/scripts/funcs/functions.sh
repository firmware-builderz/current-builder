#!/bin/bash
# colored.sh

### COLORED MESSAGES FUNCTION ###   ### COLORED MESSAGES FUNCTION ###   ### COLORED MESSAGES FUNCTION ###


eco() {
    local status="$1"
    shift
    local message="$*"
    
    case "$status" in
        info)
            echo -e "\e[34m[INFO]\e[0m $message"
            ;;
        err)
            echo -e "\e[31m[ERROR]\e[0m $message"
            ;;
        succ)
            echo -e "\e[32m[SUCCESS]\e[0m $message"
            ;;
        warn)
            echo -e "\e[33m[WARNING]\e[0m $message"
            ;;
        x)
            echo -e "\e[35m[X]\e[0m $message"
            ;;
        *)
            echo -e "\e[36m[UNKNOWN]\e[0m $message"
            ;;
    esac
}
### END COLORED MESSAGES FUNCTION ###  ### END  COLORED MESSAGES FUNCTION ### ### END  COLORED MESSAGES FUNCTION ###






# Farbcodes definieren
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"  # Reset für normale Ausgabe





### LOGGING FUNCTION ###    ### LOGGING FUNCTION ###     ### LOGGING FUNCTION ### 
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
### END LOGGING FUNCTION ###        ### END LOGGING FUNCTION ###        ### END LOGGING FUNCTION ###  



### SLEEP DELAY FUNCTION ###        ### SLEEP DELAY FUNCTION ###   ### SLEEP DELAY FUNCTION ###


dl() {
    sleep "${1:-2}"
}

### END SLEEP DELAY FUNCTION ###    ### END SLEEP DELAY FUNCTION ###        ### END SLEEP DELAY FUNCTION ###

