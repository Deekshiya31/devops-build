#!/bin/bash
# ----------------------------------------------------
# Script: check_app_health.sh - Now using simplified log alert
# ----------------------------------------------------

# Configuration
APP_URL="http://localhost:80"
LOG_FILE="/var/log/app_health.log"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Check application status
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 $APP_URL)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- HEALTH CHECK LOGIC ---
if [ "$STATUS_CODE" -eq 200 ]; then
    # SUCCESS: Log successful status
    echo "$TIMESTAMP [SUCCESS]: App is UP (Status: $STATUS_CODE)" >> "$LOG_FILE"
    exit 0
else
    # FAILURE: Log a BIG, RED ALERT that is easy to spot!
    ALERT_LINE="========================================================================================="
    
    echo "$ALERT_LINE" >> "$LOG_FILE"
    echo "$TIMESTAMP [CRITICAL FAILURE]!!! APP IS DOWN !!! Status: $STATUS_CODE on Instance: $INSTANCE_ID" >> "$LOG_FILE"
    echo "Check container status immediately. Last Successful Status: $STATUS_CODE" >> "$LOG_FILE"
    echo "$ALERT_LINE" >> "$LOG_FILE"
    
    exit 1
fi
