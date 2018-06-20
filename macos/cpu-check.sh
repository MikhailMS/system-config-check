#!/bin/sh

source ./utils/try-catch.sh

function gather_cpu_configuration() {
  try 
  (
    lCpuCount=$([[ $(get_kernel) = 'Darwin' ]] &&  sysctl -n hw.logicalcpu_max || lscpu -p | egrep -v '^#' | wc -l)
    pCpuCount=$([[ $(get_kernel) = 'Darwin' ]] && sysctl -n hw.physicalcpu_max || lscpu -p | egrep -v '^#' | sort -u -t, -k 2,4 | wc -l)
    processorDesc=$(sysctl -n machdep.cpu.brand_string)
    echo -e "${processorDesc} has {${lCpuCount}} Logical cores and {${pCpuCount}} Physical cores"
  )
  catch || {
    if [ -f /proc/cpuinfo ]; then
      cpuCount=$(grep -c ^processor /proc/cpuinfo)
      echo "General CPU(Logical or Physical) = ${cpuCount}"
    elif type -p getconf 2>/dev/null 
    then
      cpuCount=$(getconf _NPROCESSORS_ONLN || getconf NPROCESSORS_ONLN)
      echo "General CPU(Logical or Physical) = ${cpuCount}"
    fi
  }
}
