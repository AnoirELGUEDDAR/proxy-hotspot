#!/bin/bash

if [ -f "../config/config.sh" ]; then
    source ../config/config.sh
else
    echo "Error: Configuration file not found!"
    exit 1
fi

echo "================ CONNECTION DIAGNOSTIC TOOL ================"
echo "Current time: $(date)"
echo "User: $USER"
echo ""

echo "==== USB Tethering Status ===="
if ip addr show "$USB_INTERFACE" &>/dev/null; then
    echo "✓ USB interface exists"
    if ip addr show "$USB_INTERFACE" | grep -q "inet "; then
        echo "✓ USB interface has IP: $(ip addr show "$USB_INTERFACE" | grep 'inet ' | awk '{print $2}')"
    else
        echo "❌ USB interface has no IP address assigned!"
    fi
else
    echo "❌ USB tethering interface not found!"
fi

echo -e "\n==== Internet Connectivity ===="
if ping -c 1 "$DNS_PRIMARY" &>/dev/null; then
    echo "✓ Internet is working"
else
    echo "❌ No internet connectivity!"
fi

echo -e "\n==== WiFi Hotspot Status ===="
if ip addr show "$WIFI_INTERFACE" | grep -q "inet "; then
    echo "✓ Hotspot interface has IP: $(ip addr show "$WIFI_INTERFACE" | grep 'inet ' | awk '{print $2}')"
else
    echo "❌ Hotspot interface has no IP address!"
fi

echo -e "\n==== Redsocks Status ===="
if systemctl is-active --quiet redsocks; then
    echo "✓ Redsocks service is running"
else
    echo "❌ Redsocks service is not running!"
fi

echo -e "\n==== IPTables Rules Status ===="
if sudo iptables -t nat -L REDSOCKS &>/dev/null; then
    if sudo iptables -t nat -L REDSOCKS -n | grep -q "REDIRECT"; then
        echo "✓ REDSOCKS chain exists with redirection rules"
    else
        echo "❌ REDSOCKS chain exists but has no redirection rules!"
    fi
else
    echo "❌ REDSOCKS chain does not exist in iptables!"
fi

echo -e "\n==== Proxy Server Status ===="
if nc -z -w 5 "$PROXY_SERVER_IP" "$PROXY_PORT" &>/dev/null; then
    echo "✓ Proxy server is reachable"
else
    echo "❌ Cannot reach proxy server at $PROXY_SERVER_IP:$PROXY_PORT!"
fi

echo -e "\n================ DIAGNOSTIC COMPLETE =================="