#! /bin/bash

# Removed quotes so ~ expands correctly
LOG_DIR=~/portfolio/bash_scripting/01_logs
# APP_LOG="application.log" has been repalces by LOG_FILES
# SYSTEM_LOG="system.log" has been repalces by LOG_FILES
ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")
REPORT_FILE="~/portfolio/bash_scripting/log_analysis_report.txt"


echo -e "\nList of log files updated in paste ~27 years:"
echo "------------------------------------------------"
# Added quotes around the path variable to prevent globbing
LOG_FILES=$(find "$LOG_DIR" -name "*.log" -mtime -10000)
echo "$LOG_FILES"

for LOG_FILE in $LOG_FILES; do
    echo -e "\nANALYZING $LOG_FILE"
    echo "------------------------------------------------" 

for PATTERN in "${ERROR_PATTERNS[@]}"; do
        # Calculate count for this specific pattern
        COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        
        # Add to the grand total
        TOTAL_COUNT=$((TOTAL_COUNT + COUNT))

        # Output the count first
        echo "Number of ${PATTERN}s in $FILE_NAME: $COUNT"

        # Output the actual log lines if they exist
        if [ "$COUNT" -gt 0 ]; then
            echo -e "${PATTERN}s in $FILE_NAME:"
            grep "$PATTERN" "$LOG_FILE"
        fi
        echo "" # Add a small gap between patterns
    done
done

echo "=================================================="
echo "GRAND TOTAL OF ALL ERRORS: $TOTAL_COUNT"
echo "=================================================="