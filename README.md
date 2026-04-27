# Network Recon Tool

A bash script that automates network reconnaissance by scanning a target for open ports and automatically running relevant Nmap NSE scripts based on what services are detected.

I built this as my first security automation project to practice combining Nmap scanning with bash scripting. The idea came from doing manual recon on HackTheBox machines and wanting to automate the repetitive parts.

---

## What it does

1. Takes a target IP as input
2. Runs an Nmap service detection scan
3. Checks which services are open (SSH, FTP, HTTP, SMB, RDP, Telnet, Redis)
4. Automatically runs the relevant NSE scripts for each detected service
5. Saves all results to a timestamped output folder

---

## Usage

```bash
chmod +x network-recon.sh
./network-recon.sh <target-ip>
```

**Example:**
```bash
./network-recon.sh 10.10.10.1
```

---

## Example Output

```
[+] Starting scan on 10.10.10.1...

-------------------- RESULTS --------------------
[+] FTP detected on port 21
    -> Running FTP scripts...
[+] SSH detected on port 22
    -> Running SSH scripts...
[+] HTTP detected on port 80
    -> Running HTTP scripts...

[+] Scan completed. Results saved in output_2025-01-15_14-32-01/
```

Output folder structure:
```
output_2025-01-15_14-32-01/
├── results.txt      # initial scan
├── ftp.txt          # FTP NSE results
├── ssh.txt          # SSH NSE results
└── http.txt         # HTTP NSE results
```

---

## Services covered

| Port | Service | NSE Scripts |
|------|---------|-------------|
| 21   | FTP     | ftp-anon, ftp-syst |
| 22   | SSH     | ssh-auth-methods, ssh-hostkey |
| 80   | HTTP    | http-title, http-headers |
| 445  | SMB     | smb-os-discovery, smb-security-mode |
| 3389 | RDP     | rdp-enum-encryption |
| 23   | Telnet  | telnet-ntlm-info |
| 6379 | Redis   | redis-info |

---

## Requirements

- Linux / Kali Linux
- Nmap installed (`sudo apt install nmap`)

---

## What I learned building this

- How to use bash associative arrays to map ports to service names
- How to parse Nmap output with `grep` to detect open ports
- How NSE scripts work and which ones are useful per service
- How to organize output into timestamped directories for clean results

---

## Planned improvements

- Add color output to make results easier to read
- Add a `--full` flag to scan all 65535 ports
- Add more services (DNS, SMTP, MongoDB, MySQL)
- Generate a summary report file automatically
- Add automatic detection of interesting findings (anonymous FTP, vulnerable SMB)

---

## Author

Erfan Nayeb Aghaei — CS Master's student, learning cybersecurity and penetration testing.
