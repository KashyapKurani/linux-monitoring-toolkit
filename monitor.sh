#!/bin/bash

# Linux Server Monitoring Script
# Author: Kashyap Kurani
# Version: 1.0

echo "======================================================"

echo "            Linux Server Monitoring Report            "
echo ""
echo "Generated on $(date)"

echo "======================================================"



echo "======================================================"

echo "            System UPTIME            "
echo ""
uptime

echo "======================================================"



echo "======================================================"

echo "            CPU USAGE            "
echo ""
CPU_LINE=$(top -bn1 | grep "Cpu(s)")
echo "$CPU_LINE"

CPU_IDLE=$(echo "$CPU_LINE" | awk '{print $8}')
CPU_USAGE=$(echo "100-$CPU_IDLE" | bc)

echo "CPU Utilization: $CPU_USAGE%"
echo "======================================================"



echo "======================================================"

echo "            MEMORY USAGE            "
echo ""
free -h

echo "======================================================"



echo "======================================================"

echo "            DISK USAGE            "
echo ""
df -h

echo "======================================================"



echo "======================================================"

echo "             TOP 5 CPU PROCESSES            "
echo ""
ps aux --sort=-%cpu | awk 'NR<=6 {printf "%-15s %-10s %-10s %-10s %-20s\n",$1,$2,$3,$4,$11}'

echo "======================================================"


echo "======================================================"

echo "             TOP 5 MEMORY PROCESSES            "
echo ""
ps aux --sort=-%mem | awk 'NR<=6 {printf "%-15s %-10s %-10s %-10s %-20s\n",$1,$2,$3,$4,$11}'

echo "======================================================"
