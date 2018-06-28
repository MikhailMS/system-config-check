#!/bin/sh

clear
source utils/utils.sh

if [ $(get_kernel) = 'Darwin' ]; then
  source macos/computer-generics.sh
  source macos/cpu-check.sh
  source macos/network-check.sh
  source macos/memory-check.sh

  echo "$(computer_generics)"
  echo "--------------"
  echo ""
  echo "CPU Configuration"
  echo "--------------"
  echo "$(gather_cpu_configuration)"
  echo "--------------"
  echo ""
  echo "Memory Configuration"
  echo "--------------"
  echo "$(gather_memory_configuration)"
  echo "--------------"
  echo ""
  echo "Network Configuration"
  echo "--------------"
  echo "$(gather_network_configuration)"
  echo "--------------"
else
  source nix/cpu-check.sh
  source nix/memory-check.sh
  source nix/network-check.sh

  echo "CPU Configuration"
  echo "--------------"
  echo "$(gather_cpu_configuration)"
  echo "--------------"
  echo ""
  echo "Memory Configuration"
  echo "--------------"
  echo "$(gather_memory_configuration)"
  echo "--------------"
  echo ""
  echo "Network Configuration"
  echo "--------------"
  echo "$(gather_network_configuration)"
  echo "--------------"
fi
