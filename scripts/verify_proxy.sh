#!/bin/bash

# Source the configuration file
if [ -f "../config/config.sh" ]; then
    source ../config/config.sh
else
    echo "Error: Configuration file not found!"
    echo "Please copy config/config.template.sh to config/config.sh and fill in your details."
    exit 1
fi

echo "================ PROXY VERIFICATION TOOL ================"
echo "Current time: $(date)"
echo "User: $USER"
echo ""

# Step 1: Check redsocks status
echo "Step 1: Checking redsocks service status..."
if systemctl is-active --quiet redsocks || pgrep redsocks > /dev/null; then
    echo "✓ Redsocks is running"
else
    echo "❌ Redsocks is not running!"
    echo "Run fix_redsocks.sh to resolve this issue."
fi

# Step 2: Check iptables rules
echo -e "\nStep 2: Checking iptables rules..."
if sudo iptables -t nat -L REDSOCKS -n &>/dev/null; then
    if sudo iptables -t nat -L REDSOCKS -n | grep -q "REDIRECT"; then
        echo "✓ REDSOCKS chain exists with redirection rules"
    else
        echo "❌ REDSOCKS chain exists but has no redirection rules!"
    fi
    
    if sudo iptables -t nat -L PREROUTING -n | grep -q "REDSOCKS"; then
        echo "✓ Traffic is being redirected to REDSOCKS chain"
    else
        echo "❌ Traffic is NOT being redirected to REDSOCKS chain!"
    fi
else
    echo "❌ REDSOCKS chain does not exist in iptables!"
fi

# Step 3: Check proxy connectivity
echo -e "\nStep 3: Testing proxy connectivity..."
if curl --socks5 $PROXY_SERVER_IP:$PROXY_PORT -U $PROXY_USERNAME:$PROXY_PASSWORD https://api.ipify.org -s -m 10 > /tmp/proxy_ip.txt; then
    PROXY_IP=$(cat /tmp/proxy_ip.txt)
    echo "✓ Successfully connected through proxy"
    echo "✓ Your IP through proxy: $PROXY_IP"
    
    # Get current IP without proxy
    if curl https://api.ipify.org -s -m 5 > /tmp/direct_ip.txt; then
        DIRECT_IP=$(cat /tmp/direct_ip.txt)
        if [[ "$PROXY_IP" != "$DIRECT_IP" ]]; then
            echo "✓ Proxy IP differs from your direct IP - proxy is working correctly"
            echo "  Direct IP: $DIRECT_IP"
            echo "  Proxy IP: $PROXY_IP"
        else
            echo "❌ Proxy IP is the same as your direct IP - proxy might not be working!"
        fi
    fi
else
    echo "❌ Failed to connect through proxy!"
fi

# Step 4: Check WiFi hotspot status
echo -e "\nStep 4: Checking WiFi hotspot status..."
if nmcli -t -f DEVICE,STATE dev | grep -q "$WIFI_INTERFACE:connected"; then
    echo "✓ WiFi hotspot is active"
    HOTSPOT_IP=$(ip addr show $WIFI_INTERFACE | grep 'inet ' | awk '{print $2}')
    echo "✓ Hotspot IP: $HOTSPOT_IP"
else
    echo "❌ WiFi hotspot is not active!"
fi

echo -e "\n================ VERIFICATION COMPLETE =================="