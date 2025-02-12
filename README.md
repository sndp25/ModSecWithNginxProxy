# ModSecurity with Nginx Reverse Proxy

## Overview
This project demonstrates the implementation of **ModSecurity** as a Web Application Firewall (WAF) for a website using an **Nginx reverse proxy**. The primary objective is to enhance web application security by mitigating various attacks such as **SQL Injection (SQLi), Cross-Site Scripting (XSS), Local File Inclusion (LFI), Remote Code Execution (RCE)**, and many others.

This setup leverages the **OWASP Core Rule Set (CRS)** to provide a robust defense against common web vulnerabilities.

2024 summer internship project At Secuneus Tech, Jalandhar

## Features
- **Nginx as a Reverse Proxy** to handle incoming requests.
- **ModSecurity WAF** for real-time attack detection and prevention.
- **OWASP CRS** for pre-configured security rules.
- Protection against **SQLi, XSS, LFI, RCE, CSRF**, and more.
- Logging and monitoring of blocked requests.

## Installation & Setup
### Prerequisites
- Ubuntu/Debian-based system
- Nginx
- ModSecurity (libmodsecurity)
- OWASP Core Rule Set (CRS)

### Steps
#### 1. Install Required Packages
```bash
sudo apt update
sudo apt install nginx libnginx-mod-security2
```

#### 2. Enable ModSecurity in Nginx
Modify the Nginx configuration file (`/etc/nginx/nginx.conf`) to include:
```nginx
load_module modules/ngx_http_modsecurity_module.so;
```

#### 3. Configure ModSecurity
Enable ModSecurity and specify the configuration file in Nginx:
```nginx
modsecurity on;
modsecurity_rules_file /etc/nginx/modsecurity.conf;
```

#### 4. Download and Configure OWASP CRS
```bash
cd /etc/nginx/
sudo git clone https://github.com/coreruleset/coreruleset.git
sudo mv coreruleset /etc/nginx/owasp-crs
cd /etc/nginx/owasp-crs
sudo cp crs-setup.conf.example crs-setup.conf
```
Modify `/etc/nginx/modsecurity.conf` to include CRS rules:
```bash
Include /etc/nginx/owasp-crs/crs-setup.conf
Include /etc/nginx/owasp-crs/rules/*.conf
```

#### 5. Restart Nginx
```bash
sudo systemctl restart nginx
```

## Testing the Firewall
You can test the WAF by sending malicious requests:
```bash
curl http://yourdomain.com/?id=1' OR '1'='1
```
If ModSecurity is configured correctly, the request should be blocked and logged.

## Logs & Monitoring
Blocked requests and alerts are logged in:
```bash
/var/log/nginx/error.log
```

## Conclusion
This project provides a foundational setup for using ModSecurity with Nginx as a WAF. While the OWASP CRS offers strong default protection, further tuning and custom rule additions may be required based on application-specific needs.

## Author
**Sandeep Singh**

## License
This project is licensed under the MIT License.
