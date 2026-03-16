cat << 'EOF' > MariaDeep.sh
#!/bin/bash
clear

# SOLIDO AT MABAGANG BANNER
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

# 2. DATABASE REBUILD (Milyonaryo Edition)
echo "[*] Building Database with 30 Staff and 50 Multi-Millionaire Clients..."
sqlite3 bank.db <<SQL
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, role TEXT);
CREATE TABLE employees (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, position TEXT, salary REAL);
CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, balance REAL, pin TEXT);
INSERT INTO users (username, password, role) VALUES ('admin', '0192023a7bbd73250516f069df18b500', 'admin');
SQL

# SEEDING 30 STAFF
p_names=("Robert" "Jennifer" "Michael" "Michelle" "Christopher" "Maria" "Joseph" "Rizalina" "Antonio" "Ferdinand")
for i in {0..29}; do
    NAME="${p_names[$((i % 10))]} Staff-$i"
    SAL=$((45000 + RANDOM % 35000))
    USER="staff$i"
    PASS=$(echo -n "password123" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO employees (name, position, salary) VALUES ('$NAME', 'Bank Personnel', $SAL);"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'staff');"
done

# SEEDING 50 MILLIONAIRE CLIENTS (₱2M to ₱50M)
for i in {1..50}; do
    NAME="V.I.P Client-$i"
    BAL=$((2000000 + RANDOM % 48000000))
    PIN=$((1000 + RANDOM % 8999))
    USER="client$i"
    PASS=$(echo -n "$PIN" | md5sum | cut -d' ' -f1)
    sqlite3 bank.db "INSERT INTO customers (id, name, balance, pin) VALUES ($i, '$NAME', $BAL, '$PIN');"
    sqlite3 bank.db "INSERT INTO users (username, password, role) VALUES ('$USER', '$PASS', 'client');"
done

# 3. CSS (WHITE THEME - ORIGINAL LOOK)
cat << 'CSS' > style.css
body { font-family: sans-serif; background: #f0f2f5; margin: 0; display: flex; }
.sidebar { width: 250px; background: #001f3f; color: white; height: 100vh; position: fixed; padding: 20px; }
.main { margin-left: 250px; padding: 30px; width: 100%; overflow-y: auto; }
.card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 4px solid #001f3f; }
table { width: 100%; border-collapse: collapse; font-size: 11px; }
th, td { padding: 8px; text-align: left; border-bottom: 1px solid #eee; }
.btn { width: 100%; padding: 10px; margin-top: 10px; background: #001f3f; color: gold; border: none; cursor: pointer; border-radius: 5px; font-weight: bold; }
.terminal { background: #000; color: #39ff14; padding: 10px; border-radius: 5px; font-family: monospace; }
CSS
cp style.css login/style.css

# 4. DASHBOARD (FIXED IDOR & MILLIONS DISPLAY)
cat << 'PHP' > dash.php
<?php if(!isset($_COOKIE['auth'])) { header("Location: login/"); exit(); } $db = new SQLite3('bank.db'); ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"><title>SadMaria Dashboard</title></head>
<body><div class="sidebar"><h2>SADMARIA</h2><p>Operator: <b><?php echo $_COOKIE['auth']; ?></b></p><hr>
<a href="dash.php" style="color:white; text-decoration:none;">🏠 Home</a><br><br>
<a href="logout.php" style="color:red; text-decoration:none;">🚪 Logout</a></div>
<div class="main">
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
        <div class="card"><h3>💸 Money Transfer (IDOR)</h3>
            <form method="POST"><input name="f" placeholder="Sender ID" style="width:100%; padding:8px; margin:5px 0;">
            <input name="t" placeholder="Receiver ID" style="width:100%; padding:8px; margin:5px 0;">
            <input name="a" placeholder="Amount (₱)" style="width:100%; padding:8px; margin:5px 0;">
            <button type="submit" class="btn">TRANSFER MILLIONS</button></form>
            <?php if($_SERVER['REQUEST_METHOD']=='POST'){
                $f=$_POST['f']; $t=$_POST['t']; $a=$_POST['a'];
                $db->exec("UPDATE customers SET balance = balance - $a WHERE id = $f");
                $db->exec("UPDATE customers SET balance = balance + $a WHERE id = $t");
                echo "<p style='color:green; font-weight:bold;'>₱".number_format($a)." Sent Successfully!</p>";
            } ?>
        </div>
        <div class="card"><h3>💻 RCE Terminal (Deface Tool)</h3><form><input name="c" placeholder="sh command..." style="width:100%; padding:8px;"></form>
            <div class="terminal"><pre><?php if(isset($_GET['c'])) { echo shell_exec($_GET['c']); } ?></pre></div>
        </div>
    </div>
    <div class="card"><h3>🌍 V.I.P Clients (₱ Milyonaryo Targets)</h3><div style="max-height:200px; overflow-y:auto;"><table>
    <tr><th>ID</th><th>Name</th><th>Balance (Millions)</th></tr>
    <?php $r=$db->query("SELECT * FROM customers"); while($row=$r->fetchArray()){ 
        echo "<tr><td>{$row['id']}</td><td>{$row['name']}</td><td style='color:green; font-weight:bold;'>₱".number_format($row['balance'])."</td></tr>"; } ?>
    </table></div></div>
    <div class="card"><h3>👔 Bank Staff (30 Positions)</h3><div style="max-height:150px; overflow-y:auto;"><table>
    <?php $r=$db->query("SELECT * FROM employees"); while($row=$r->fetchArray()){ 
        echo "<tr><td>{$row['name']}</td><td>{$row['position']}</td><td>₱".number_format($row['salary'])."</td></tr>"; } ?>
    </table></div></div>
    <div class="card" style="border-top: 5px solid red;"><h3>🔓 LEAKED CREDENTIALS (MD5)</h3><table>
    <?php $r=$db->query("SELECT * FROM users LIMIT 15"); while($row=$r->fetchArray()){ 
        echo "<tr><td><code>{$row['username']}</code></td><td><small>{$row['password']}</small></td><td>{$row['role']}</td></tr>"; } ?>
    </table></div>
    <div style="text-align:center; font-weight:bold; color:#001f3f; margin-top:20px;">BY SADFRIENDS</div>
</div></body></html>
PHP

# 5. LOGIN PAGE
cat << 'PHP' > login/index.php
<?php $db = new SQLite3('../bank.db'); if($_SERVER['REQUEST_METHOD']=='POST'){
$u=$_POST['u']; $p=md5($_POST['p']); $res=$db->query("SELECT * FROM users WHERE username='$u' AND password='$p'");
if($user=$res->fetchArray()){ setcookie("auth",$user['username'],time()+3600,"/"); header("Location:../dash.php"); exit(); }
else { $err="Invalid Access!"; }} ?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"></head>
<body style="justify-content:center; align-items:center; display:flex; height:100vh; background:#001f3f; margin:0;">
<div style="background:white; padding:40px; border-radius:15px; width:300px; text-align:center; border-top: 5px solid gold;">
<h2 style="color:#001f3f;">SADMARIA 🏦</h2><p style="color:gray; font-size:11px;">Official Pentest Portal</p>
<form method="POST"><input name="u" placeholder="Username" style="width:100%; padding:10px; margin:5px 0; border:1px solid #ccc; border-radius:5px;">
<input type="password" name="p" placeholder="Password" style="width:100%; padding:10px; margin:5px 0; border:1px solid #ccc; border-radius:5px;">
<button class="btn">LOGIN</button></form><p style="color:red; font-size:11px;"><?php echo @$err; ?></p></div></body></html>
PHP

echo "<?php setcookie('auth', '', time()-3600, '/'); header('Location: login/'); ?>" > logout.php
echo "<?php header('Location: login/'); ?>" > index.php

# LAUNCH
echo -e "\e[1;32m[+] SadMaria V36 is ONLINE at http://localhost:8080/login/\e[0m"
php -S localhost:8080
EOF

bash MariaDeep.sh
