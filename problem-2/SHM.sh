#!/usr/bin/env bash
set -euo pipefail

CPU_THR=80
MEM_THR=90
DSK_THR=90
PROC_THR=0
MOUNT_PATH="/"
LOG_FILE=""

while getopts "c:m:d:p:f:l:" opt; do
  case "$opt" in
    c) CPU_THR="$OPTARG" ;;
    m) MEM_THR="$OPTARG" ;;
    d) DSK_THR="$OPTARG" ;;
    p) PROC_THR="$OPTARG" ;;
    f) MOUNT_PATH="$OPTARG" ;;
    l) LOG_FILE="$OPTARG" ;;
  esac
done

log(){ [[ -n "$LOG_FILE" ]] && echo "[$(date -Is)] $*" >> "$LOG_FILE" || echo "$*"; }

cpu_usage(){
  read -r _ a b c d e f g _ < /proc/stat
  idle1=$((d + e)); total1=$((a+b+c+d+e+f+g))
  sleep 1
  read -r _ a b c d e f g _ < /proc/stat
  idle2=$((d + e)); total2=$((a+b+c+d+e+f+g))
  awk -v i1="$idle1" -v t1="$total1" -v i2="$idle2" -v t2="$total2" 'BEGIN{print (1-((i2-i1)/(t2-t1)))*100}'
}

mem_usage(){
  mt=$(grep -m1 MemTotal /proc/meminfo | awk '{print $2}')
  ma=$(grep -m1 MemAvailable /proc/meminfo | awk '{print $2}')
  awk -v t="$mt" -v a="$ma" 'BEGIN{print (1-(a/t))*100}'
}

disk_usage(){
  df -P "$MOUNT_PATH" | awk 'NR==2 {gsub("%","",$5); print $5}'
}

proc_count(){
  ps -e --no-headers | wc -l
}

STATUS=0

CPU=$(printf "%.0f" "$(cpu_usage)")
MEM=$(printf "%.0f" "$(mem_usage)")
DSK=$(disk_usage)
PROCS=$(proc_count)

log "cpu=${CPU}% mem=${MEM}% disk(${MOUNT_PATH})=${DSK}% procs=${PROCS}"

if (( CPU > CPU_THR )); then log "ALERT: CPU>${CPU_THR}%"; STATUS=2; fi
if (( MEM > MEM_THR )); then log "ALERT: MEM>${MEM_THR}%"; STATUS=2; fi
if (( DSK > DSK_THR )); then log "ALERT: DISK>${DSK_THR}% on ${MOUNT_PATH}"; STATUS=2; fi
if (( PROC_THR > 0 && PROCS > PROC_THR )); then log "ALERT: PROCS>${PROC_THR}"; STATUS=2; fi

exit $STATUS

