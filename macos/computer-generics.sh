#!/bin/sh

source ./utils/utils.sh

function computer_generics() {
  _kernel=$(get_kernel)
  _kernel_version=$(get_kernel_version)
  _kernel_release=$(get_kernel_release)

  # Get computer name
  _computername=$(scutil --get ComputerName)

  # Get serial number
  _serialnumber=$(system_profiler SPHardwareDataType |grep "Serial Number (system)" |awk '{print $4}'  | cut -d/ -f1)

  # Get operating system name and version
  _osvers1=$( sw_vers -productVersion | cut -d. -f1 )
  _osvers2=$( sw_vers -productVersion | cut -d. -f2 )
  _osvers3=$( sw_vers -productVersion | cut -d. -f3 )
  case $_osvers2 in
    8)
      _osname="Mountain Lion"
    ;;
    9)
      _osname="Mavericks"
    ;;
    10)
      _osname="Yosemite"
    ;;
    11)
      _osname="El Capitan"
    ;;
    12)
      _osname="Sierra"
    ;;
    13)
      _osname="High Sierra"
    ;;
    default)
      _osname="Unknown"
    ;;
  esac

  echo "$_computername"
  echo "--------------"
  echo "      Computer OS:  Mac OS X - $_osname $_osvers1.$_osvers2.$_osvers3"
  echo "  Computer Kernel:  ${_kernel_version} - ${_kernel_release}"  
  echo "    Computer Name:  $_computername"
  echo "Current User Name:  $(whoami)"
  echo "    Serial Number:  $_serialnumber"
  echo ""
}
