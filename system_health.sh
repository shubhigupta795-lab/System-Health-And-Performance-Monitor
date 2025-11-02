#!/bin/bash
# ======================================================
#   SYSTEM HEALTH AND PERFORMANCE MONITOR (Unix)
# ======================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOGFILE="health_report_$(date +%F_%H-%M-%S).log"

echo -e "${BLUE}==============================================${NC}"
echo -e "${YELLOW}      SYSTEM HEALTH CHECKUP REPORT${NC}"
echo -e "${BLUE}==============================================${NC}"
echo "Generated on: $(date)"
echo "----------------------------------------------"
echo "" >> "$LOGFILE"

# -------------------- Uptime --------------------
echo -e "${GREEN}  UPTIME:${NC}"
uptime -p | tee -a "$LOGFILE"

# -------------------- CPU Usage --------------------
echo -e "\n${GREEN} CPU USAGE:${NC}"
top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"

# -------------------- Memory Usage --------------------
echo -e "\n${GREEN} MEMORY USAGE (in MB):${NC}"
free -m | awk 'NR==1{printf "%-10s %-10s %-10s\n", $1, $2, $3}
NR==2{printf "%-10s %-10s %-10s\n", $1, $2, $3}' | tee -a "$LOGFILE"

# -------------------- Disk Usage --------------------
echo -e "\n${GREEN} DISK USAGE:${NC}"
df -h | grep -v tmpfs | tee -a "$LOGFILE"

# -------------------- Top 5 Processes --------------------
echo -e "\n${GREEN} TOP 5 MEMORY-CONSUMING PROCESSES:${NC}"
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -6 | tee -a "$LOGFILE"

# -------------------- Network Connectivity --------------------
echo -e "\n${GREEN} NETWORK CONNECTIVITY:${NC}"
if ping -c 1 google.com &> /dev/null
then
    echo -e "${GREEN} Internet is working${NC}" | tee -a "$LOGFILE"
else
    echo -e "${RED} No Internet Connection${NC}" | tee -a "$LOGFILE"
fi

# -------------------- Temperature Sensors --------------------
echo -e "\n${GREEN} TEMPERATURE SENSORS:${NC}"
if command -v sensors &> /dev/null
then
    sensors | head -5 | tee -a "$LOGFILE"
else
    echo -e "${YELLOW}  sensors command not installed${NC}" | tee -a "$LOGFILE"
fi

# -------------------- Logged-in Users --------------------
echo -e "\n${GREEN} LOGGED-IN USERS:${NC}"
who | tee -a "$LOGFILE"

# -------------------- End Message --------------------
echo -e "\n${BLUE}==============================================${NC}"
echo -e "${YELLOW} HEALTH CHECK COMPLETED SUCCESSFULLY${NC}"
echo -e "${BLUE}==============================================${NC}"
echo -e "Report saved as: ${GREEN}$LOGFILE${NC}"

