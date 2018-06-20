#!/bin/sh

function get_kernel() {
  uname
}

function get_kernel_version() {
  uname -v
}

function get_kernel_release() {
  uname -r
}

function get_hostname() {
  uname -n
}

# Converts IP Subnet Mask to CIDR
function mask2cdr () {
  # Assumes there's no "255." after a non-255 byte in the mask
  local x=${1##*255.}
  set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
  x=${1%%$3*}
  echo $(( $2 + (${#x}/4) ))
}

