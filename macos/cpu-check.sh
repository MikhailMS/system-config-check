#!/bin/sh

source ./utils/try-catch.sh

function gather_cpu_configuration() {
  try 
  (
    _lCpuCount=$([[ $(get_kernel) = 'Darwin' ]] &&  sysctl -n hw.logicalcpu_max || lscpu -p | egrep -v '^#' | wc -l)
    _pCpuCount=$([[ $(get_kernel) = 'Darwin' ]] && sysctl -n hw.physicalcpu_max || lscpu -p | egrep -v '^#' | sort -u -t, -k 2,4 | wc -l)
    _processorDesc=$(sysctl -n machdep.cpu.brand_string)
    echo -e "${_processorDesc} has {${_lCpuCount}} Logical cores and {${_pCpuCount}} Physical cores"
  )
  catch || {
    if [ -f /proc/cpuinfo ]; then
      _cpuCount=$(grep -c ^processor /proc/cpuinfo)
    elif type -p getconf 2>/dev/null 
    then
      _cpuCount=$(getconf _NPROCESSORS_ONLN || getconf NPROCESSORS_ONLN)
    fi
    echo "General CPU(Logical or Physical) = ${_cpuCount}"    
  }
}
