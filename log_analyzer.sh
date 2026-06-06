#!/bin/bash

check_log_file() {

    ## Check if log file is provided    
    if [ -z "$LOG_FILE" ]; then
        echo "Usage: ./log_analyzer.sh <log_file>"
        exit 1
    fi

    ## Check if log file exists
    if [ ! -f "$LOG_FILE" ]; then
        echo "Error: File not found!"
        exit 1
    fi
}


## Basic statistics
show_statistics() {
    
    echo "======================================================"
    echo "LOG ANALYSIS REPORT"
    echo "======================================================"
    echo "Log File: $LOG_FILE"

    local TOTAL_LINES=$(wc -l < "$LOG_FILE")
    local ERROR_COUNT=$(grep -ic "ERROR" "$LOG_FILE")
    local WARNING_COUNT=$(grep -ic "WARNING" "$LOG_FILE")
    local INFO_COUNT=$(grep -ic "INFO" "$LOG_FILE")
    local FAILED_LOGINS=$(grep -ic "FAILED_LOGIN" "$LOG_FILE")

    if [ "$ERROR_COUNT" -gt 10 ]; then
        local STATUS="CRITICAL"
    elif [ "$WARNING_COUNT" -gt 5 ]; then
        local STATUS="WARNING"
    else
        local STATUS="HEALTHY"
    fi

    echo ""
    echo "Log File              : $LOG_FILE"
    echo "Total Lines           : $TOTAL_LINES"
    echo "INFO Count            : $INFO_COUNT"
    echo "WARNING Count         : $WARNING_COUNT"
    echo "ERROR Count           : $ERROR_COUNT"
    echo "FAILED LOGIN ATTEMPTS : $FAILED_LOGINS"
    echo "Status                : $STATUS"
    echo ""
    echo "======================================================"
}

 
## Display last 10 error messages
show_recent_errors() {
    echo ""
    echo "LAST 10 ERRORS"

    grep -i "ERROR" "$LOG_FILE" | tail -10
}


## Extract and count unique error messages
show_top_errors() {
    echo ""
    echo "TOP ERROR MESSAGES"

    grep -i "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=""; print $0}' \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5
}


## Extract IP addresses and count occurrences
show_top_ips() {
    echo ""
    echo "TOP IP ADDRESSES"

    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5
}


## Extract and count failed login attempts by username
show_failed_logins() {    
    echo ""
    echo "FAILED LOGIN DETAILS"

    grep -i "FAILED_LOGIN" "$LOG_FILE" \
    | awk '{print $4}' \
    | sort \
    | uniq -c \
    | sort -nr
}


## Ensure at least one log file was provided as an argument
if [ "$#" -eq 0 ]; then
    echo "Usage: ./log_analyzer.sh <log_file>"
    exit 1
fi

for LOG_FILE in "$@"; do
    echo "Analyzing log file: $LOG_FILE"
    check_log_file
    show_statistics
    show_recent_errors
    show_top_errors
    show_top_ips
    show_failed_logins
    echo
    echo "######################################################"
    echo
done