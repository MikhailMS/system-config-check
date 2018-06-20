#!/bin/sh

source ./utils/utils.sh

function computer_generics() {
  kernel=$(get_kernel)
  kernel_version=$(get_kernel_version)
  kernel_release=$(get_kernel_release)

  # Get computer name
  computername=$(scutil --get ComputerName)

  # Get serial number
  sSerialNumber=$(system_profiler SPHardwareDataType |grep "Serial Number (system)" |awk '{print $4}'  | cut -d/ -f1)

  # Get operating system name and version
  OSvers1=$( sw_vers -productVersion | cut -d. -f1 )
  OSvers2=$( sw_vers -productVersion | cut -d. -f2 )
  OSvers3=$( sw_vers -productVersion | cut -d. -f3 )
  case $OSvers2 in
    8)
      OSName="Mountain Lion"
    ;;
    9)
      OSName="Mavericks"
    ;;
    10)
      OSName="Yosemite"
    ;;
    11)
      OSName="El Capitan"
    ;;
    12)
      OSName="Sierra"
    ;;
    13)
      OSName="High Sierra"
    ;;
    default)
      OSName="Unknown"
    ;;
  esac

  echo "$computername"
  echo "--------------"
  echo "      Computer OS:  Mac OS X - $OSName $OSvers1.$OSvers2.$OSvers3"
  echo "  Computer Kernel:  ${kernel_version} - ${kernel_release}"  
  echo "    Computer Name:  $computername"
  echo "Current User Name:  $(whoami)"
  echo "    Serial Number:  $sSerialNumber"
  echo ""
}
