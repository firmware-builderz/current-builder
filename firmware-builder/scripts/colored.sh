#!/bin/bash
# colored.sh


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
