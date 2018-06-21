#!/bin/sh

source ./utils/try-catch.sh
source ./utils/utils.sh

function get_memory_total() {
  if type -p free >/dev/null 2>&1; then
    _total=$(free -h | awk '/^Mem:/{print $2}')
    echo $(convert_gb_to_mb $_total)
  elif [ -f '/proc/meminfo' ]
  then
    _total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    echo $(_total/1024^2)
  fi
}

function get_memory_available() {
  if type -p free >/dev/null 2>&1; then
    _available=$(free -h | awk '/^Mem:/{print $7}')
    echo $(convert_gb_to_mb $_available)
  elif [ -f '/proc/meminfo' ]
  then
    _available=$(grep MemAvail /proc/meminfo | awk '{print $2}')
    echo _available/1024^2
  fi
}

function get_memory_all() {
  if [ type -p free ]; then
    free -h
  elif [ -f '/proc/meminfo' ]
  then
    grep Mem /proc/meminfo && grep Swap /proc/meminfo
  fi
}

function get_disc_stats() {
  df -h
}

function gather_memory_configuration() {
  memTotal=$(get_memory_total)
  memAvailable=$(get_memory_available)
  let usage=(memTotal - memAvailable)*100/memTotal

  echo "Physical Memory: Total = ${memTotal} Mb, Available = ${memAvailable} Mb, usage = ${usage} %"
  echo "Disc Stats:"
  echo "  ------>>"
  get_disc_stats
}
