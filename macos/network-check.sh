#!/bin/sh

source ./utils/utils.sh

function gather_network_configuration() {
  # List all Network ports
  NetworkPorts=$(ifconfig -uv | grep '^[a-z0-9]' | awk -F : '{print $1}')

  echo "Active Networks:"
  echo "--------------"

  for val in $NetworkPorts; do   # Get for all available hardware ports their status
    # echo $val
    activated=$(ifconfig -uv "$val" | grep 'status: ' | awk '{print $2}')
    # echo $activated 
    if [ "$activated" = 'active' ]; then
      label=$(ifconfig -uv "$val" | grep 'type' | awk '{print $2}')
      ActiveNetworkName=$(networksetup -listallhardwareports | grep -B 1 "$label" | awk '/Hardware Port/{ print }'|cut -d " " -f3- | uniq)
      state=$(ifconfig -uv "$val" | grep 'status: ' | awk '{print $2}')
      ipaddress=$(ifconfig -uv "$val" | grep 'inet ' | awk '{print $2}')
      # echo $ipaddress

      if [[ -z $(ifconfig -uv "$val" | grep 'link rate: ' | awk '{print $3, $4}' | sed 'N;s/\n/ up /' ) ]]; then
        networkspeed="$(ifconfig -uv "$val" | grep 'link rate: ' | awk '{print $3}' ) up/down"
      else
        networkspeed="$(ifconfig -uv "$val" | grep 'link rate: ' | awk '{print $3, $4}' | sed 'N;s/\n/ up /' ) down"
      fi

      macaddress=$(ifconfig -uv "$val" | grep 'ether ' | awk '{print $2}')
      quality=$(ifconfig -uv "$val" | grep 'link quality:' | awk '{print $3, $4}')
      netmask=$(ipconfig getpacket "$val" | grep 'subnet_mask (ip):' | awk '{print $3}')
      router=$(ipconfig getpacket "$val" | grep 'router (ip_mult):' | sed 's/.*router (ip_mult): {\([^}]*\)}.*/\1/')
      DHCPActive=$(networksetup -getinfo "Wi-Fi" | grep DHCP)
      dnsserver=$(networksetup -getdnsservers "$ActiveNetworkName" | awk '{print $1, $2}' | sed 'N;s/\n//' )

      if [[ -z $dnsserver ]]; then
        dnsserver=$(scutil --dns | grep 'search domain' | awk '{ print $4 }' | tr " " "\n" | sed -n '2p')
        dnsipList=$(scutil --dns | grep 'nameserver' | sort | uniq | tr ":" "\n")
        dnsipStr=""
        for ip in $dnsipList; do
          if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            dnsipStr+="$ip "
          fi
        done
        dnsserver="$dnsserver, IP: $dnsipStr"
      fi

      if [[ $ipaddress ]]; then
        echo "  $ActiveNetworkName ($val)"
        echo "  ------>>"
        # Is this a WiFi associated port? If so, then we want the network name
        if [ "$label" = "Wi-Fi" ]; then
          WiFiName=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep '\sSSID:' | sed 's/.*: //')
          #echo $WiFiName
          echo "     Network Name:  $WiFiName"
        fi

        echo "       IP Address:  $ipaddress"
        echo "      Subnet Mask:  $netmask"
        echo "           Router:  $router"
        echo "          IP CIDR:  $ipaddress/$(mask2cdr $netmask)"

        if [[ -z $dnsserver ]]; then
          if [[ $DHCPActive ]]; then
          echo "       DNS Server:  Set With DHCP"
          else
          echo "       DNS Server:  Unknown"
          fi
        else
          echo "       DNS Server:  $dnsserver"
        fi

        echo "      MAC-address:  $macaddress"
        echo "    Network Speed:  $networkspeed"
        echo "     Link quality:  $quality"
        echo " "
      fi
      # Don't display the inactive ports.
    fi
  done
}
