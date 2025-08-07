#!/bin/bash

# Source the configuration file
if [ -f "../config/config.sh" ]; then
    source ../config/config.sh
else
    echo "Error: Configuration file not found!"
    echo "Please copy config/config.template.sh to config/config.sh and fill in your details."
    exit 1
fi

echo "================ PROXY HOTSPOT SETUP ================"
echo "Current time: $(date)"
echo "User: $USER"
echo ""

# Step 1: Verify Internet connectivity through USB tethering
echo "Step 1: Verifying internet through USB tethering..."
if ping -c 1 8.8.8.8 &>/dev/null; then
    echo "✓ Internet connectivity through USB tethering is working"
else
    echo "❌ No internet through USB tethering! Check your phone's connection."
    echo "Make sure mobile data is enabled on your phone."
    exit 1
fi

# Step 2: Enable IP forwarding
echo -e "\nStep 2: Enabling IP forwarding..."
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Step 3: Create redsocks configuration
echo -e "\nStep 3: Creating redsocks configuration..."
sudo bash -c "cat > /etc/redsocks.conf << EOF
base {
    log_debug = off;
    log_info = on;
    log = \"stderr\";
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 0.0.0.0;
    local_port = 12345;
    
    ip = $PROXY_SERVER_IP;
    port = $PROXY_PORT;
    
    type = socks5;
    login = \"$PROXY_USERNAME\";
    password = \"$PROXY_PASSWORD\";
}
EOF"

# ... rest of the script with variables ...