cat << 'EOF' > MariaDeep.sh
#!/bin/bash
clear

# MABAGANG BANNER (BOLD BLOCK STYLE)
echo -e "\e[1;35m"
echo "███████╗ █████╗ ██████╗ ███╗   ███╗ █████╗ ██████╗ ██╗ █████╗ "
echo "██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔══██╗██║██╔══██╗"
echo "███████╗███████║██║  ██║██╔████╔██║███████║██████╔╝██║███████║"
echo "╚════██║██╔══██║██║  ██║██║╚██╔╝██║██╔══██║██╔══██╗██║██╔══██║"
echo "███████║██║  ██║██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║██║██║  ██║"
echo "╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝"
echo -e "\e[1;33m              >> BY: SADFRIENDS <<\e[0m"
echo ""

echo -e "\e[1;31m[!] DISCLAIMER: FOR EDUCATIONAL AND PENTESTING PURPOSES ONLY.\e[0m"
echo -e "\e[1;34m[*] DEPLOYING MARIABANK V36: THE ULTIMATE PENTEST LAB...\e[0m"

# 1. SETUP DIRECTORIES
rm -rf ~/maria_banko && mkdir -p ~/maria_banko/login ~/maria_banko/uploads
cd ~/maria_banko
pkg install php sqlite -y > /dev/null 2>&1

# 2. DATABASE REBUILD (SOLIDO SETUP)
echo "[*] Initializing Database Tables..."
sqlite3 bank.db <<SQL
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, role TEXT);
CREATE TABLE employees (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, position TEXT, salary REAL);
CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT, job TEXT, balance REAL, pin TEXT);
INSERT INTO users (username, password, role) VALUES ('admin', '0192023a7bbd73250516f069df18b500', 'admin');
SQL

# DATA SEEDING (COMPLETELY FIXED LOOPS)
p_names=("Robert Garcia" "Jennifer Santos" "Michael Mendoza" "Michelle Cruz" "Christopher Reyes" "Maria Theresa" "Joseph Gonzales" "Rizalina Reyes" "Antonio Luna" "Ferdinand Marcos")
p_jobs=("Branch Manager" "Security Head" "Senior Teller" "IT Support" "Loan Officer")

for i in {0..29}; do
    NAME="${p_names[$((i % 10))]} $i"
    JOB="${p_jobs[$((i % 5))]}"
    USER=$(echo $NAME | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')$i
    PASS=$(echo -n "password123" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO employees (name, email, position, salary) VALUES ('$NAME', '${USER}@mb.ph', '$JOB', $((25000+RANDOM%20000)));"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'staff');"
done

for i in {0..19}; do
    NAME="Client $i"
    PIN=$((1000 + RANDOM % 8999))
    BAL=$((2000000 + RANDOM % 48000000))
    USER="client$((i+1))"
    PASS=$(echo -n "$PIN" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO customers (name, country, job, balance, pin) VALUES ('$NAME', 'Global', 'Investor', $BAL, '$PIN');"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'client');"
done

# 3. CSS (ORIGINAL WHITE/BLUE THEME)
cat << 'CSS' > style.css
body { font-family: sans-serif; background: #f0f2f5; margin: 0; display: flex; }
.sidebar { width: 250px; background: #001f3f; color: white; height: 100vh; position: fixed; padding: 20px; box-sizing: border-box; }
.main { margin-left: 250px; padding: 30px; width: 100%; overflow-y: auto; }
.card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 4px solid #001f3f; }
table { width: 100%; border-collapse: collapse; font-size: 12px; color: #333; }
th, td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
input { width: 100%; padding: 10px; margin-top: 5px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box; }
.btn { width: 100%; padding: 12px; margin-top: 10px; background: #001f3f; color: gold; border: none; cursor: pointer; font-weight: bold; border-radius: 5px; }
.terminal { background: #000; color: #39ff14; padding: 10px; border-radius: 5px; font-family: monospace; }
CSS
cp style.css login/style.css

# 4. PHP PAGES (LOGIN & DASHBOARD)
cat << 'PHP' > login/index.php
<?php $db = new SQLite3('../bank.db'); $err = "";
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $u = $_POST['u']; $p = md5($_POST['p']);
    $q = "SELECT * FROM users WHERE username = '$u' AND password = '$p'";
    $res = $db->query($q);
    if ($user = $res->fetchArray()) { setcookie("auth", $user['username'], time()+3600, "/"); header("Location: ../dash.php"); exit(); }
    else { $err = "Access Denied!"; }
} ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"></head>
<body style="justify-content:center; align-items:center; display:flex; height:100vh; background:#001f3f; margin:0;">
<div style="background:white; padding:40px; border-radius:15px; width:300px; text-align:center;">
<h2 style="color:#001f3f; margin:0;">SADMARIA 🏦</h2><p style="color:gray; font-size:11px;">By SadFriends</p>
<form method="POST"><input name="u" placeholder="Username" required><input type="password" name="p" placeholder="Password" required><button class="btn">LOGIN</button></form>
<p style="color:red; font-size:11px;"><?php echo $err; ?></p></div></body></html>
PHP

cat << 'PHP' > dash.php
<?php if(!isset($_COOKIE['auth'])) { header("Location: login/"); exit(); } $db = new SQLite3('bank.db'); ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"><title>Dashboard</title></head>
<body><div class="sidebar"><h2>SADMARIA</h2><p>User: <b><?php echo $_COOKIE['auth']; ?></b></p><hr>
<a href="dash.php" style="color:white; text-decoration:none;">🏠 Dashboard</a><br><br><a href="logout.php" style="color:red; text-decoration:none;">🚪 Logout</a></div>
<div class="main">
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
        <div class="card"><h3>💸 Transfer (IDOR)</h3>
            <form method="POST"><input name="f" placeholder="From ID"><input name="t" placeholder="To ID"><input name="a" placeholder="Amount"><button class="btn">SEND</button></form>
            <?php if($_SERVER['REQUEST_METHOD']=='POST'){ 
                $db->exec("UPDATE customers SET balance=balance-{$_POST['a']} WHERE id={$_POST['f']}");
                $db->exec("UPDATE customers SET balance=balance+{$_POST['a']} WHERE id={$_POST['t']}");
                echo "<p style='color:green; font-size:12px;'>Transferred!</p>"; } ?>
        </div>
        <div class="card"><h3>💻 RCE Terminal</h3><form><input name="c" placeholder="sh command..."></form>
            <div class="terminal"><pre><?php if(isset($_GET['c'])) { echo shell_exec($_GET['c']); } ?></pre></div>
        </div>
    </div>
    <div class="card"><h3>👔 Bank Staff (Pinoy)</h3><table>
    <?php $r=$db->query("SELECT * FROM employees LIMIT 8"); while($row=$r->fetchArray()){ echo "<tr><td>{$row['name']}</td><td><b>{$row['position']}</b></td></tr>"; } ?>
    </table></div>
    <div class="card" style="border-top: 5px solid red;"><h3>🔓 LEAKED CREDENTIALS (MD5)</h3><table>
    <?php $r=$db->query("SELECT * FROM users LIMIT 10"); while($row=$r->fetchArray()){ $p=($row['role']=='admin')?'admin123':'password123';
    echo "<tr><td><code>{$row['username']}</code></td><td><b>$p</b></td><td><small>{$row['password']}</small></td></tr>"; } ?>
    </table></div>
    <div style="text-align:center; color:#001f3f; font-weight:bold; font-size:12px;">BY SADFRIENDS</div>
</div></body></html>
PHP

echo "<?php setcookie('auth', '', time()-3600, '/'); header('Location: login/'); ?>" > logout.php
echo "<?php header('Location: login/'); ?>" > index.php

# LAUNCH
echo -e "\e[1;32m[+] SadMaria V36 is ONLINE at http://localhost:8080/login/\e[0m"
php -S localhost:8080
EOF

bash MariaDeep.sh
