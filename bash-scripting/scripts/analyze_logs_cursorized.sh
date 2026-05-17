#!/bin/bash
#
# Handout 01 — completed “cursorized” log analysis script.
# Implements multi-file scan, error-pattern counts, matching lines, and a saved report.

LOG_DIR=~/portfolio/bash_scripting/sample_logs
ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")
REPORT_FILE="${HOME}/portfolio/bash_scripting/log_analysis_report.txt"

TOTAL_COUNT=0

{
    echo "LOG ANALYSIS REPORT"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo ""

    echo "Log files under ${LOG_DIR} (find: *.log, -mtime -10000):"
    echo "------------------------------------------------"
    LOG_FILES=$(find "$LOG_DIR" -name "*.log" -mtime -10000)
    echo "$LOG_FILES"
    echo ""

    for LOG_FILE in $LOG_FILES; do
        FILE_NAME=$(basename "$LOG_FILE")
        FILE_TOTAL=0

        echo ""
        echo "ANALYZING $LOG_FILE"
        echo "------------------------------------------------"

        for PATTERN in "${ERROR_PATTERNS[@]}"; do
            COUNT=$(grep -c "$PATTERN" "$LOG_FILE" 2>/dev/null) || true
            COUNT=${COUNT:-0}

            TOTAL_COUNT=$((TOTAL_COUNT + COUNT))
            FILE_TOTAL=$((FILE_TOTAL + COUNT))

            echo "Number of ${PATTERN} matches in ${FILE_NAME}: ${COUNT}"

            if [ "${COUNT}" -gt 0 ]; then
                echo "${PATTERN} lines in ${FILE_NAME}:"
                grep "$PATTERN" "$LOG_FILE"
            fi
            echo ""
        done

        echo "Subtotal (${FILE_NAME}): ${FILE_TOTAL} matches across all patterns"
        echo ""
    done

    echo "=================================================="
    echo "GRAND TOTAL OF ALL ERROR/FATAL/CRITICAL MATCHES: ${TOTAL_COUNT}"
    echo "=================================================="
} | tee "$REPORT_FILE"

echo ""
echo "Report also saved to: ${REPORT_FILE}"
