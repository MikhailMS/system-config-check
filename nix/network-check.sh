#!/bin/sh

source ./utils/utils.sh

function gather_network_configuration() {
  if type -p ip >/dev/null 2>&1; then
    activeinterlist=$(ip link show | grep -Pzo '^[^\t:]+:([^\n]|\n\t)*state UP' | awk '{ print $2 }' | tr -d :)
    inactiveinterlist=$(ip link show | grep -Pzo '^[^\t:]+:([^\n]|\n\t)*state DOWN' | awk '{ print $2 }' | tr -d :)
    if [[ -z $activeinterlist ]]; then
      activeinterlist=$(ip link show | grep -Pzo '^[^\t:]+:([^\n]|\n\t)*status: active' | awk '{ print $2 }' | tr -d :)
    fi
    if [[ -z $inactiveinterlist ]]; then
      inactiveinterlist=$(ip link show | grep -Pzo '^[^\t:]+:([^\n]|\n\t)*status: inactive' | awk '{ print $2 }' | tr -d :)
    fi
  fi

  if [[ ! -z $activeinterlist ]]; then
    echo "Active Networks:"
    echo "--------------"

    for interface in $activeinterlist; do
      if type -p nmcli >/dev/null 2>&1; then
        type=$(nmcli device show $interface | grep 'TYPE' | awk '{ print $2 }')
        ip4cidr=$(nmcli device show $interface | grep 'IP4.ADDRESS' | awk '{ print $2 }')
        ip4addr=${ip4cidr::-3}
        ip4gateway=$(nmcli device show $interface | grep 'IP4.GATEWAY' | awk '{ print $2 }')
        netmask=$(ifconfig $interface | grep -E '(^|\s)inet($|\s)' | awk '{ print $4 }')
        dnsip=$(nmcli device show $interface | grep 'IP4.DNS' | awk '{ print $2 }')
        ip6addr=$(nmcli device show $interface | grep 'IP6.ADDRESS' | awk '{ print $2 }')
        macaddr=$(nmcli device show $interface | grep 'GENERAL.HWADDR' | awk '{ print $2 }')

        if type -p ethtool >/dev/null 2>&1; then
          networkspeed=$(ethtool $interface 2>&1 | grep 'Speed:' | awk '{ print $2 }')
        else
          networkspeed='Unknown'
        fi

        echo "  ${type^} ($interface)"
        echo "  ------>>"
        echo "       IP Address:  $ip4addr"
        echo "      Subnet Mask:  $netmask"
        echo "Router/Gateway IP:  $ip4gateway"
        echo "          IP CIDR:  $ip4cidr"
        echo "     IP 6 Address:  $ip6addr"

        if [[ -z $dnsip ]]; then
          echo "       DNS Server:  Unknown"
        else
          echo "       DNS Server:  $dnsip"
        fi

        echo "      MAC-address:  $macaddr"
        echo "    Network Speed:  $networkspeed"
        echo "  <<------"
        echo ""

      else
        ip4info=$(ifconfig $interface | grep -P '(^|\s)\Kinet(?=\s|$)')
        ip6info=$(ifconfig $interface | grep -P '(^|\s)\Kinet6(?=\s|$)')
        
        ip4addr=$(echo $ip4info | awk '{ print $2 }')
        netmask=$(echo $ip4info | awk '{ print $4 }')
        
        echo "       IP Address:  $ip4addr"
        echo "      Subnet Mask:  $netmask"
        # echo "       Gateway IP:  $ip4gateway"
        # echo "           Router:  $router"
        # echo "          IP CIDR:  $ip4cidr"
        # echo "    IP 6 Address:  $ip6addr"

        # if [[ -z $dnsip ]]; then
        #   echo "       DNS Server:  Unknown"
        # else
        #   echo "       DNS Server:  $dnsip"
        # fi

        # echo "      MAC-address:  $macaddr"
        # echo "    Network Speed:  $networkspeed"
        # echo "     Link quality:  $quality"
        echo "  <<------"
        echo ""
      fi
    done

    echo "--------------"
    echo "Inactive Networks:"
    echo "--------------"

    for interface in $inactiveinterlist; do
      if type -p nmcli >/dev/null 2>&1; then
        type=$(nmcli device show $interface | grep 'TYPE' | awk '{ print $2 }')
        macaddr=$(nmcli device show $interface | grep 'GENERAL.HWADDR' | awk '{ print $2 }')

        echo ""
        echo "  ------>>"
        echo "      Interface #:  $interface"
        echo "    Iterface Type:  $type"
        echo "      MAC-address:  $macaddr"
        echo "  <<------" 
      else
        macaddr=$(ifconfig $interface | grep ether | awk '{ print $2 }')

        echo ""
        echo "  ------>>"
        echo "      Interface #:  $interface"
        echo "    Iterface Type:  Unknown"
        echo "      MAC-address:  $macaddr"
        echo "  <<------" 
      fi
    done
  fi
}
