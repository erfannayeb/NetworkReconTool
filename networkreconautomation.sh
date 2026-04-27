#!/bin/bash
# Automated Network Reconnaissance Tool
# Author: Erfan Nayeb Aghaei
# Description: Detects open ports and runs service-specific Nmap NSE scripts



target=$1

if [ -z "$target" ]; then
  echo "Usage: ./script.sh <target>"
  exit 1
fi

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output_dir="output_$timestamp"
mkdir -p "$output_dir"

echo "[+] Starting scan on $target..."
nmap  -sV "$target" -oN "$output_dir/results.txt"


echo "-------------------- RESULTS --------------------"

declare -A services=(
["22"]="SSH"
["21"]="FTP"
["80"]="HTTP"
["445"]="SMB"
["3389"]="RDP"
["23"]="Telnet"
["6379"]="Redis"
)



for port in "${!services[@]}"; do
  if grep -q "$port/tcp open" "$output_dir/results.txt"; then
    echo "[+] ${services[$port]} detected on port $port"

 # ---------------- NSE SCRIPTS ----------------

    if [ "$port" == "22" ]; then
      echo "    -> Running SSH scripts..."
      nmap -p 22 --script=ssh-auth-methods,ssh-hostkey "$target"  -oN "$output_dir/ssh.txt"

    elif [ "$port" == "80" ]; then
      echo "    -> Running HTTP scripts..."
      nmap -p 80 --script=http-title,http-headers "$target"  -oN "$output_dir/http.txt"

    elif [ "$port" == "21" ]; then
      echo "    -> Running FTP scripts..."
      nmap -p 21 --script=ftp-anon,ftp-syst "$target"  -oN "$output_dir/ftp.txt"

    elif [ "$port" == "445" ]; then
      echo "    -> Running SMB scripts..."
      nmap -p 445 --script=smb-os-discovery,smb-security-mode "$target"  -oN "$output_dir/smb.txt"

    elif [ "$port" == "3389" ]; then
      echo "    -> Running RDP scripts..."
      nmap -p 3389 --script=rdp-enum-encryption "$target"  -oN "$output_dir/rdp.txt"

    elif [ "$port" == "6379" ]; then
      echo "    -> Running Redis scripts..."
      nmap -p 6379 --script=redis-info "$target" -oN "$output_dir/redis.txt"
    fi

  fi
done


echo "[+] Scan completed. Results saved in $output_dir"
