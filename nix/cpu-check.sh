#!/bin/sh

source ./utils/try-catch.sh

function gather_cpu_configuration() {
  try 
  (
  if [ -f /proc/cpuinfo ]; then
    cpuCount=$(grep -c ^processor /proc/cpuinfo)
    echo "General CPU(Logical or Physical) = ${cpuCount}"
  elif type -p getconf 2>/dev/null 
  then
    cpuCount=$(getconf _NPROCESSORS_ONLN || getconf NPROCESSORS_ONLN)
    echo "General CPU(Logical or Physical) = ${cpuCount}"
  fi
  )
  catch || {
    echo "Something went wrong and script is unable to retrieve CPU stats"
  }
}
