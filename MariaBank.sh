cat << 'EOF' > SadMaria_V36.sh
#!/bin/bash
clear

# 1. BANNER & DISCLAIMER
echo -e "\e[1;35m"
echo "  ____            _ __  __            _        "
echo " / ___|  __ _  __| |  \/  | __ _ _ __(_) __ _  "
echo " \___ \ / _\` |/ _\` | |\/| |/ _\` | '__| |/ _\` | "
echo "  ___) | (_| | (_| | |  | | (_| | |  | | (_| | "
echo " |____/ \__,_|\__,_|_|  |_|\__,_|_|  |_|\__,_| "
echo "                                               "
echo "           >> BY: SADFRIENDS <<                "
echo -e "\e[0m"

echo -e "\e[1;31m[!] DISCLAIMER: THIS SOFTWARE IS FOR EDUCATIONAL AND PENTESTING PURPOSES ONLY.\e[0m"
echo -e "\e[1;31m[!] ILLEGAL USE OF THIS TOOL IS STRICTLY PROHIBITED. USE AT YOUR OWN RISK.\e[0m"
echo -e "\e[1;34m[*] DEPLOYING MARIABANK V36: THE ULTIMATE PENTEST LAB...\e[0m"

# 2. SETUP DIRECTORIES
rm -rf ~/maria_banko && mkdir -p ~/maria_banko/login ~/maria_banko/uploads
cd ~/maria_banko
pkg install php sqlite -y > /dev/null 2>&1

# 3. DATABASE REBUILD
echo "[*] Building Database with Jobs, Positions, and Millions..."
sqlite3 bank.db <<SQL
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, role TEXT);
CREATE TABLE employees (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, position TEXT, salary REAL);
CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT, job TEXT, balance REAL, pin TEXT);
INSERT INTO users (username, password, role) VALUES ('admin', '0192023a7bbd73250516f069df18b500', 'admin');
SQL

# DATA ARRAYS
p_names=("Robert Garcia" "Jennifer Santos" "Michael Mendoza" "Michelle Cruz" "Christopher Reyes" "Maria Theresa" "Joseph Gonzales" "Rizalina Reyes" "Antonio Luna" "Ferdinand Marcos")
p_jobs=("Branch Manager" "Security Head" "Senior Teller" "IT Support" "Loan Officer")
g_names=("John Miller" "Yuki Tanaka" "Hans Schmidt" "Svetlana Sokolov" "Chen Li" "Amir Hassan" "Carlos Ortega" "Jean Pierre" "Kim Ji-soo" "Steve Jobs")
g_jobs=("CEO" "Crypto Investor" "Oil Magnate" "Real Estate Owner" "Stock Trader")

# SEEDING 30 STAFF
for i in {0..29}; do
    NAME="${p_names[$((i % 10))]} $i"
    JOB="${p_jobs[$((i % 5))]}"
    USER=$(echo $NAME | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')$i
    PASS=$(echo -n "password123" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO employees (name, email, position, salary) VALUES ('$NAME', '${USER}@mb.ph', '$JOB', $((25000+RANDOM%20000)));"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'staff');"
done

# SEEDING 20 RICH CLIENTS
for i in {0..19}; do
    NAME="${g_names[$((i % 10))]} $i"
    JOB="${g_jobs[$((i % 5))]}"
    PIN=$((1000 + RANDOM % 8999))
    BAL=$((2000000 + RANDOM % 48000000))
    USER="client$((i+1))"
    PASS=$(echo -n "$PIN" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO customers (name, country, job, balance, pin) VALUES ('$NAME', 'Global', '$JOB', $BAL, '$PIN');"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'client');"
done

# 4. CREATE CSS
cat << 'CSS' > style.css
body { font-family: sans-serif; background: #0f0c29; color: #eee; margin: 0; display: flex; }
.sidebar { width: 250px; background: #1a1a2e; color: white; height: 100vh; position: fixed; padding: 20px; box-sizing: border-box; border-right: 2px solid #e94560; }
.main { margin-left: 250px; padding: 30px; width: 100%; overflow-y: auto; }
.card { background: #16213e; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.3); border-top: 4px solid #e94560; }
table { width: 100%; border-collapse: collapse; font-size: 11px; }
th, td { padding: 10px; text-align: left; border-bottom: 1px solid #0f3460; }
input { width: 100%; padding: 10px; margin-top: 5px; border-radius: 5px; border: 1px solid #e94560; background: #1a1a2e; color: white; box-sizing: border-box; }
.btn { width: 100%; padding: 12px; margin-top: 10px; background: #e94560; color: white; border: none; cursor: pointer; font-weight: bold; border-radius: 5px; }
.terminal { background: #000; color: #39ff14; padding: 10px; border-radius: 5px; font-family: monospace; border: 1px solid #333; }
.footer { text-align: center; color: #e94560; font-size: 10px; margin-top: 20px; font-weight: bold; }
CSS
cp style.css login/style.css

# 5. LOGIN PAGE
cat << 'PHP' > login/index.php
<?php $db = new SQLite3('../bank.db'); $err = "";
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $u = $_POST['u']; $p = md5($_POST['p']);
    $q = "SELECT * FROM users WHERE username = '$u' AND password = '$p'";
    $res = $db->query($q);
    if ($user = $res->fetchArray()) { setcookie("auth", $user['username'], time()+3600, "/"); header("Location: ../dash.php"); exit(); }
    else { $err = "Login failed! SadFriends System Protection Active."; }
} ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"></head>
<body style="justify-content:center; align-items:center; display:flex; height:100vh; background:#0f0c29; margin:0;">
<div style="background:#1a1a2e; padding:40px; border-radius:15px; width:300px; text-align:center; border: 2px solid #e94560;">
<h2 style="color:#e94560; margin:0;">SADMARIA 🏦</h2><p style="color:gray; font-size:11px;">By SadFriends</p>
<form method="POST"><input name="u" placeholder="Username" required><input type="password" name="p" placeholder="Password" required><button class="btn">ENTER SYSTEM</button></form>
<p style="color:#e94560; font-size:11px;"><?php echo $err; ?></p></div></body></html>
PHP

# 6. DASHBOARD
cat << 'PHP' > dash.php
<?php if(!isset($_COOKIE['auth'])) { header("Location: login/"); exit(); } $db = new SQLite3('bank.db'); ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"><title>Dashboard</title></head>
<body><div class="sidebar"><h2 style="color:#e94560;">SADMARIA</h2><p>Operator: <b><?php echo $_COOKIE['auth']; ?></b></p><hr style="border: 0.5px solid #333;">
<a href="dash.php" style="color:white; text-decoration:none;">🏠 Dashboard</a><br><br><a href="logout.php" style="color:#e94560; text-decoration:none;">🚪 Logout</a></div>
<div class="main">
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
        <div class="card"><h3>💸 Money Transfer (IDOR)</h3>
            <form method="POST"><input name="f" placeholder="Sender Account ID"><input name="t" placeholder="Receiver Account ID"><input name="a" placeholder="Amount"><button class="btn">SEND FUNDS</button></form>
            <?php if($_SERVER['REQUEST_METHOD']=='POST'){ $f=$_POST['f']; $t=$_POST['t']; $a=$_POST['a'];
                $db->exec("UPDATE customers SET balance=balance-$a WHERE id=$f");
                $db->exec("UPDATE customers SET balance=balance+$a WHERE id=$t");
                echo "<p style='color:#39ff14; font-size:12px;'>Success: ₱".number_format($a)." Transferred.</p>"; } ?>
        </div>
        <div class="card"><h3>💻 RCE Terminal</h3><form><input name="c" placeholder="sh command..."></form>
            <div class="terminal"><pre><?php if(isset($_GET['c'])) { echo shell_exec($_GET['c']); } ?></pre></div>
        </div>
    </div>
    <div class="card"><h3>👔 Bank Staff (Pinoy)</h3><div style="max-height:150px; overflow-y:auto;"><table><tr><th>Name</th><th>Position</th></tr>
    <?php $r=$db->query("SELECT * FROM employees"); while($row=$r->fetchArray()){ echo "<tr><td>{$row['name']}</td><td><b>{$row['position']}</b></td></tr>"; } ?>
    </table></div></div>
    <div class="card"><h3>🌍 Rich Clients (Targets)</h3><div style="max-height:150px; overflow-y:auto;"><table><tr><th>ID</th><th>Name</th><th>Balance</th></tr>
    <?php $r=$db->query("SELECT * FROM customers"); while($row=$r->fetchArray()){ echo "<tr><td>{$row['id']}</td><td><b>{$row['name']}</b></td><td>₱".number_format($row['balance'])."</td></tr>"; } ?>
    </table></div></div>
    <div class="card" style="border-top: 5px solid red;"><h3>🔓 LEAKED CREDENTIALS INDEX (MD5)</h3><table><tr><th>User</th><th>Plain Pass</th><th>Role</th><th>Hash</th></tr>
    <?php $r=$db->query("SELECT * FROM users"); while($row=$r->fetchArray()){ $un=$row['username']; $role=$row['role'];
        $p = ($role=='admin') ? 'admin123' : (($role=='staff') ? 'password123' : 'Check PIN');
        echo "<tr><td><code>$un</code></td><td><b style='color:#e94560;'>$p</b></td><td>$role</td><td><small>{$row['password']}</small></td></tr>"; } ?>
    </table></div>
    <div class="footer">STAY SAD | BY SADFRIENDS</div>
</div></body></html>
PHP

echo "<?php setcookie('auth', '', time()-3600, '/'); header('Location: login/'); ?>" > logout.php
echo "<?php header('Location: login/'); ?>" > index.php

# LAUNCH
echo -e "\e[1;32m[+] SadMaria V36 is ONLINE at http://localhost:8080/login/\e[0m"
php -S localhost:8080
EOF

bash SadMaria_V36.sh
