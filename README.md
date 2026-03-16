

### 🏦 SadMaria V36 - The Ultimate Pentest Lab
*Developed by: SadFriends*

!https://img.shields.io/ !https://invalid.invalid/

### ⚠️ DISCLAIMER
*FOR EDUCATIONAL PURPOSES ONLY.*
SadMaria V36 is created for cybersecurity training and penetration testing exercises. Any misuse outside a controlled environment is not the responsibility of *SadFriends*.
### 🚀 KEY FEATURES
- *Massive Data Seeding:* Automatically generates *30 Pinoy Staff* and *20 Global Wealthy Clients* (balances up to ₱48M).
### - *Dynamic SQLite3 Backend:* Real-time database updates for transfers and user management.
### - *SadFriends Dark Aesthetic:* Modern "hacker-style" UI with custom *SadMaria* terminal banner.
- *Interactive Dashboard:* Includes RCE terminal, staff records, and client target list.
### 🚨 SECURITY DEFICIENCIES (Vulnerabilities)
This lab is intentionally vulnerable for your training:
### 1. SQL Injection (SQLi)
- *Where:* `login/index.php`
- *Deficiency:* Uses raw user input in SQL query without sanitization.
  - *Exploit:* Try using `sqlmap` or payloads like `' OR 1=1 --`.

### 2. Remote Code Execution (RCE)
- *Where:* `dash.php` (Terminal Card)
- *Deficiency:* Unfiltered access to `shell_exec()` via GET parameters.
- *Exploit:* Execute OS commands like `ls`, `whoami`, or `cat /etc/passwd`.

### 3. Insecure Direct Object Reference (IDOR)
- *Where:* `dash.php` (Transfer Form)
- *Deficiency:* No validation of ownership of Account IDs.
- *Exploit:* Change Sender ID to steal balance from other users.

### 4. Sensitive Data Exposure (Credential Leaks)
- *Where:* Dashboard Footer
- *Deficiency:* Public display of user MD5 hashes and roles.
### - *Exploit:* Practice MD5 hash cracking and rainbow table attacks.
### 🛠️ INSTALLATION & RUN
1. Copy the script to your terminal (Termux/Linux).
2. Run the command:
bash SadMaria_V36. Open browser and go to: `http://localhost:8080/login/`
   

*"Stay Sad, Stay Secure."* – *SadFriends*
