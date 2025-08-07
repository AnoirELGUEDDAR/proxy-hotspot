#!/bin/bash
# Configuration template for proxy hotspot
# Copy this file to config.sh and fill in your details

# Proxy server details
PROXY_SERVER_IP="your.proxy.server.ip"
PROXY_PORT="5102"
PROXY_USERNAME="your_username"
PROXY_PASSWORD="your_password"

# Network configuration
USB_INTERFACE="enx9aeb80c3a6b7"  # Your USB tethering interface
WIFI_INTERFACE="wlo1"            # Your WiFi interface
WIFI_SSID="ProxyHotspot"         # Your WiFi hotspot SSID
WIFI_PASSWORD="your_password"    # Your WiFi hotspot password

# DNS settings (defaults to Google DNS)
DNS_PRIMARY="8.8.8.8"
DNS_SECONDARY="8.8.4.4"