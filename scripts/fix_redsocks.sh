#!/bin/bash

if [ -f "../config/config.sh" ]; then
    source ../config/config.sh
else
    echo "Error: Configuration file not found!"
    exit 1
fi

echo "================ REDSOCKS FIX TOOL ================"
echo "Current time: $(date)"
echo "User: $USER"
echo ""

echo "Stopping redsocks service..."
sudo systemctl stop redsocks
sudo killall redsocks 2>/dev/null

echo "Creating redsocks configuration..."
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

sudo chmod 644 /etc/redsocks.conf

echo "Testing redsocks configuration syntax..."
if sudo redsocks -t -c /etc/redsocks.conf; then
    echo "✓ Configuration syntax is correct"
else
    echo "❌ Configuration syntax is invalid!"
fi

echo "Restarting redsocks service..."
sudo systemctl restart redsocks
sleep 2

if systemctl is-active --quiet redsocks; then
    echo "✅ SUCCESS: Redsocks service is now running!"
else
    echo "❌ Redsocks service still failing."
fi

echo -e "\n================ REDSOCKS FIX COMPLETE =================="