# Proxy Hotspot

This project provides a set of shell scripts to easily set up a **transparent WiFi hotspot** that routes all traffic through a SOCKS5 proxy. It is designed for Linux systems and is ideal for sharing proxied internet (for privacy, location change, or bypassing restrictions) with multiple devices **without configuring each device individually**.

---

## What Does This Project Do?

- **Creates a WiFi hotspot** on your Linux computer.
- **Shares your mobile data** via USB tethering.
- **Redirects all client traffic through a SOCKS5 proxy** (using [redsocks](https://github.com/darkk/redsocks)), so devices connected to the hotspot appear to be browsing from the proxy's location.
- **Automates diagnostics and repairs** for common problems.
- **No need for client configuration**—just connect to the WiFi!

---

## How Does It Work? (Step-by-Step)

1. **USB Tethering**  
   You connect your phone to your Linux PC using USB and enable mobile data sharing.

2. **WiFi Hotspot Creation**  
   The PC creates a WiFi hotspot (e.g., `ProxyHotspot`) using NetworkManager.

3. **Proxy Redirection via redsocks**  
   All traffic from clients is intercepted and transparently redirected to a SOCKS5 proxy using iptables and redsocks.

4. **iptables Rules**  
   The PC uses iptables to NAT and redirect traffic, ensuring only public internet traffic goes through the proxy (local/private access is excluded).

5. **Transparent Experience**  
   Devices connected to the hotspot automatically use the proxy, with no need for manual proxy settings or apps.

6. **Diagnostics & Repair Scripts**  
   Included scripts check your setup, troubleshoot issues, and repair the redsocks proxy configuration if needed.

---

## Installation & Usage Tutorial

### 1. Prerequisites

- **Linux system** (tested on Ubuntu/Debian)
- **NetworkManager** (`nmcli`)
- **WiFi card** supporting AP mode
- **USB cable** to connect your phone
- **SOCKS5 proxy credentials** (get from your provider)
- **Mobile data** enabled on your phone

### 2. Clone the Repository

```bash
git clone https://github.com/AnoirELGUEDDAR/proxy-hotspot.git
cd proxy-hotspot
```

### 3. Install Required Packages

Run the install script (requires sudo/root):

```bash
sudo ./install.sh
```

This will install: redsocks, NetworkManager, iptables-persistent, curl, netcat-openbsd.

### 4. Configure Your Proxy and Network

Copy the template and edit your details:

```bash
cp config/config.template.sh config/config.sh
nano config/config.sh
```

Fill in the following (get details from your provider and network):

```bash
PROXY_SERVER_IP="your.proxy.server.ip"
PROXY_PORT="5102"
PROXY_USERNAME="your_username"
PROXY_PASSWORD="your_password"

USB_INTERFACE="enx9aeb80c3a6b7"  # Find using `ip link`
WIFI_INTERFACE="wlo1"            # Find using `ip link`
WIFI_SSID="ProxyHotspot"
WIFI_PASSWORD="your_wifi_password"

DNS_PRIMARY="8.8.8.8"
DNS_SECONDARY="8.8.4.4"
```

### 5. Set Up the Proxy Hotspot

```bash
sudo ./scripts/setup_proxy.sh
```

### 6. Connect Devices

- On your phone, enable USB tethering.
- On other devices, connect to the WiFi hotspot:
  - **SSID:** as set in `config.sh` (default: ProxyHotspot)
  - **Password:** as set in `config.sh`

### 7. Test and Troubleshoot

- **Verify proxy is working:**
  ```bash
  sudo ./scripts/verify_proxy.sh
  ```
- **Diagnose issues:**
  ```bash
  sudo ./scripts/diagnose_cnx.sh
  ```
- **Repair redsocks if needed:**
  ```bash
  sudo ./scripts/fix_redsocks.sh
  ```

### 8. Enable Auto-Start (optional)

Set up the hotspot to run at every boot:
```bash
sudo ./scripts/create_autostart.sh
```

---

## FAQ & Tips

- **What IP will clients see?**  
  The public IP of your SOCKS5 proxy (not your home/mobile IP).

- **Can I use any proxy?**  
  Yes, as long as it supports SOCKS5 and your credentials are valid.

- **How do I find my network interfaces?**  
  Run `ip link` and look for your USB (usually starts with `enx`) and WiFi (`wlo1`, `wlan0`, etc).

- **Does this work on every Linux distro?**  
  Designed for Ubuntu/Debian, may work with tweaks on others.

- **What if redsocks fails?**  
  Run `fix_redsocks.sh` or check your proxy credentials and config.

---

## License

MIT License. See [LICENSE](LICENSE).

---

## Maintainer

Anoir EL GUEDDAR  
Contact via GitHub issues for questions or suggestions.
