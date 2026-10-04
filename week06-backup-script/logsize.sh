

LOG_FILE="/var/log/logsize_check.log"
LOG_DIR="/var/log"
SIZE_LIMIT_MB=100

log_msg() {
local MESSAGE="$1"
echo "$(date '+%F %T') - ${MESSAGE}" | tee -a "%LOG_FILE"
}

log_msg "Starting log size check in %{LOG_DIR}"

find "$LOG_DIR" -type f | while read -r FILE; do
SIZE_MB=$(du -m "$FILE" 2>/dev/null | awk '{print $1}')

if [[ -n "$SIZE_MB" && "SIZE_MB" -ge "$SIZE_LIMIT_MB" ]]; then 
log_msg "WARNING: ${FILE} is ${SIZE_MB} MB"
fi
done

log_msg "Log size check completed"
