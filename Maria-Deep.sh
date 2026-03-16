cat << 'EOF' > MariaDeep.sh
#!/bin/bash
clear
echo -e "\e[1;35m███████╗ █████╗ ██████╗ ███╗   ███╗ █████╗ ██████╗ ██╗ █████╗ \e[0m"
echo -e "\e[1;35m██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔══██╗██║██╔══██╗\e[0m"
echo -e "\e[1;35m███████╗███████║██║  ██║██╔████╔██║███████║██████╔╝██║███████║\e[0m"
echo -e "\e[1;35m╚════██║██╔══██║██║  ██║██║╚██╔╝██║██╔══██║██╔══██╗██║██╔══██║\e[0m"
echo -e "\e[1;35m███████║██║  ██║██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║██║██║  ██║\e[0m"
echo -e "\e[1;35m╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝\e[0m"
echo -e "\e[1;33m              >> BY: SADFRIENDS <<\e[0m\n"
echo -e "\e[1;31m[!] DISCLAIMER: FOR EDUCATIONAL AND PENTESTING PURPOSES ONLY.\e[0m"
echo -e "\e[1;34m[*] DEPLOYING MARIABANK V36: THE ULTIMATE PENTEST LAB...\e} Staff-$i"; u="staff$i"; pass=$(echo -n "password123" | md5sum | cut -d' ' -f1); sqlite3 bank.db "INSERT INTO employees(name,position,salary) VALUES('$n','Banker',$((45000+RANDOM%30000))); INSERT INTO users(username,password,role) VALUES('$u','$pass','staff');"; done
c=("John Wick" "Elon Musk" "Yuki Tanaka" "Svetlana" "Chen Wei" "Amir" "Carlos" "Jean" "Hans" "Sarah" "Kim" "Bruce" "Tony" "Natasha" "Peter"); for i in {1..50}; do n="${c[$((i%15))]} #$i"; b=$((2000000+RANDOM%48000000)); pin=$((1000+RANDOM%8999)); pass=$(echo -n "$pin" | md5sum | cut -d' ' -f1); sqlite3 bank.db "INSERT INTO customers(id,name,balance,pin) VALUES($i,'$n',$b,'$pin'); INSERT INTO users(username,password,role) VALUES('client$i','$pass','client');"; done

# 3. WEB CORE (CSS & PHP)
cat << 'CSS' > style.css
body{font-family:sans-serif;background:#f0f2f5;margin:0;display:flex}.sidebar{width:250px;background:#001f3f;color:white;height:100vh;position:fixed;padding:20px}.main{margin-left:250px;padding:30px;width:calc(100% - 250px);overflow-y:auto}.card{background:white;padding:20px;border-radius:12px;margin-bottom:20px;box-shadow:0 4px 6px rgba(0,0,0,0.1);border-top:4px solid #001f3f}table{width:100%;border-collapse:collapse;font-size:11px}th,td{padding:8px;text-align:left;border-bottom:1px solid #eee}.btn{width:100%;padding:12px;margin-top:10px;background:#001f3f;color:gold;border:none;cursor:pointer;border-radius:5px;font-weight:bold}.terminal{background:#000;color:#39ff14;padding:10px;border-radius:5px;font-family:monospace}
CSS
cp style.css login/style.css

cat << 'PHP' > dash.php
<?php if(!isset($_COOKIE['auth'])){header("Location:login/");exit();}$db=new SQLite3('bank.db');$msg="";if($_SERVER['REQUEST_METHOD']=='POST'&&isset($_POST['f'])){$f=(int)$_POST['f'];$t=(int)$_POST['t'];$a=(float)str_replace(',','',$_POST['a']);if($a>0){$db->exec("UPDATE customers SET balance=balance-$a WHERE id=$f");$db->exec("UPDATE customers SET balance=balance+$a WHERE id=$t");$msg="₱".number_format($a)." sent!";}}?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"><title>Dashboard</title></head><body><div class="sidebar"><h2>SADMARIA</h2><p>User: <b><?php echo $_COOKIE['auth'];?></b></p><hr><a href="dash.php" style="color:white;text-decoration:none">🏠 Home</a><br><br><a href="logout.php" style="color:red;text-decoration:none">🚪 Logout</a></div><div class="main"><div style="display:grid;grid-template-columns:1fr 1fr;gap:20px"><div class="card"><h3>💸 Transfer Millions (IDOR)</h3><form method="POST"><input name="f" placeholder="Sender ID" style="width:100%;padding:8px;margin:5px 0"><input name="t" placeholder="Receiver ID" style="width:100%;padding:8px;margin:5px 0"><input name="a" placeholder="Amount (₱)" style="width:100%;padding:8px;margin:5px 0"><button type="submit" class="btn">EXECUTE TRANSFER</button></form><p style="color:green;font-weight:bold"><?php echo $msg;?></p></div><div class="card"><h3>💻 RCE (Type 'deface')</h3><form><input name="c" placeholder="command..." style="width:100%;padding:8px"></form><div class="terminal"><pre><?php if(isset($_GET['c'])){if($_GET['c']=='deface'){file_put_contents('index.php','<body style="background:black;color:red;text-align:center;padding-top:100px;font-family:monospace"><h1>HACKED BY SADFRIENDS</h1><p>SYSTEM PWNED</p></body>');echo "DEFACED SUCCESSFULLY!";}else{echo shell_exec($_GET['c']);}}?></pre></div></div></div><div class="card"><h3>🌍 Targets (₱ Millions)</h3><div style="max-height:200px;overflow-y:auto"><table><tr><th>ID</th><th>Name</th><th>Balance</th></tr><?php $r=$db->query("SELECT * FROM customers");while($row=$r->fetchArray()){echo "<tr><td>{$row['id']}</td><td>{$row['name']}</td><td style='color:green;font-weight:bold'>₱".number_format($row['balance'])."</td></tr>";}?></table></div></div><div class="card"><h3>👔 Bank Staff</h3><div style="max-height:150px;overflow-y:auto"><table><?php $r=$db->query("SELECT * FROM employees");while($row=$r->fetchArray()){echo "<tr><td>{$row['name']}</td><td>₱".number_format($row['salary'])."</td></tr>";}?></table></div></div><div style="text-align:center;font-weight:bold;color:#001f3f">BY SADFRIENDS</div></div></body></html>
PHP

cat << 'PHP' > login/index.php
<?php $db=new SQLite3('../bank.db');if($_SERVER['REQUEST_METHOD']=='POST'){$u=$_POST['u'];$p=md5($_POST['p']);$res=$db->query("SELECT * FROM users WHERE username='$u' AND password='$p'");if($user=$res->fetchArray()){setcookie("auth",$user['username'],time()+3600,"/");header("Location:../dash.php");exit();}}?>
<!DOCTYPE html><html><head><link rel="stylesheet" href="style.css"></head><body style="justify-content:center;align-items:center;display:flex;height:100vh;background:#001f3f;margin:0"><div style="background:white;padding:40px;border-radius:15px;width:300px;text-align:center"><h2>SADMARIA 🏦</h2><p style="color:gray;font-size:11px">By SadFriends</p><form method="POST"><input name="u" placeholder="Username" style="width:100%;padding:10px;margin:5px 0;border:1px solid #ccc"><input type="password" name="p" placeholder="Password" style="width:100%;padding:10px;margin:5px 0;border:1px solid #ccc"><button class="btn">LOGIN</button></form></div></body></html>
PHP

echo "<?php setcookie('auth','',time()-3600,'/');header('Location:login/'); ?>" > logout.php
echo "<?php header('Location:login/'); ?>" > index.php

# 4. FINAL LAUNCH
echo -e "\e[1;32m[+] SadMaria V36 is ONLINE at http://localhost:8080/login/\e[0m"
php -S localhost:8080
EOF
bash MariaDeep.sh
