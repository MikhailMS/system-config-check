#!/bin/sh

source ./utils/try-catch.sh
source ./utils/utils.sh

function get_memory_total() {
  if type -p free ; then
    free -h |awk '/^Mem:/{print $2}'
  elif [ -f '/proc/meminfo' ]
  then
    _total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    echo $(_total/1024^2)
  elif [ $(get_kernel)=='Darwin' ]
  then
    _used=$(top -l 1 -s 0 | grep PhysMem | awk '{ print $2 }')
    _available=$(top -l 1 -s 0 | grep PhysMem | awk '{ print $6 }')
    
    _used=$(convert_gb_to_mb $_used)
    _available=$(convert_gb_to_mb $_available)

    echo $(($_used+$_available))
  fi
}

function get_memory_available() {
  if type -p free ; then
    free -h | awk '/^Mem:/{print $7}'
  elif [ -f '/proc/meminfo' ]
  then
    _available=$(grep MemAvail /proc/meminfo | awk '{print $2}')
    echo _available/1024^2
  elif [ $(get_kernel)=='Darwin' ]
  then
    _available=$(top -l 1 -s 0 | grep PhysMem | awk '{ print $6 }')

    if [ $(echo $_used | grep G) ]; then
      _available=$(echo $_available | tr -dc '0-9')
      let _available=$_available*1000
    else
      _available=$(echo $_available | tr -dc '0-9')
    fi
    echo $_available
  fi
}

function get_memory_all() {
  if [ type -p free ]; then
    free -h
  elif [ -f '/proc/meminfo' ]
  then
    grep Mem /proc/meminfo && grep Swap /proc/meminfo
  elif [ $(get_kernel)=='Darwin' ]
  then
    echo $(top -l 1 -s 0 | grep PhysMem)
  fi
}

function get_disc_stats() {
  df -h
}

function gather_memory_configuration() {
  _memTotal=$(get_memory_total)
  _memAvailable=$(get_memory_available)
  let _usage=(_memTotal - _memAvailable)*100/_memTotal

  echo "Physical Memory: Total = ${_memTotal} Mb, Available = ${_memAvailable} Mb, usage = ${_usage} %"
  echo "Disc Stats:"
  echo "  ------>>"
  get_disc_stats
}
