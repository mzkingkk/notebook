set -e

log_file="/tmp/ssh.log"
password=''
ip="192.168.1.1"

echo "" >$log_file

function logger() {
    msg=$1
    echo -e "---------------${msg}---------------"
    echo $msg >>$log_file
}

function autoscp() {
    filepath=${shell_clash_path}
    logger "${filepath}"

    if [[ ! -f "${filepath}/start.sh" ]]; then
        logger " shell_clash_path not exits, or the path is empty"
        exit -1
    fi
    logger "start upload......"

    sleep 3s
    set +e
    /usr/bin/expect <<EOF
set timeout 10
spawn scp -r -p ${filepath} admin@${ip}:/etc/storage
expect "*assword:"
send "$password\n"
send "exit\n"
expect eof
EOF

    logger "send file successful!"
    set -e
}

function autorestart() {
    logger "start restart..."
    sleep 1s

    /usr/bin/expect <<EOF
set timeout 10
spawn ssh admin@${ip}
expect "*assword:"
send "$password\n"
expect "*#"
send "sed -i '/export CRASHDIR=*/'d /etc/profile && echo -e 'export CRASHDIR=/etc/storage/ShellCrash' >> /etc/profile\n"
expect "*#"
send "sed -i '/alias crash=*/'d /etc/profile && echo -e 'alias crash=/etc/storage/ShellCrash/menu.sh' >> /etc/profile\n"
expect "*#"
send "sed -i '/alias clash=*/'d /etc/profile && echo -e 'alias clash=/etc/storage/ShellCrash/menu.sh' >> /etc/profile\n"
expect "*#"
send "source /etc/profile\n"
expect "*#"
send "chmod 755 -R /etc/storage/ShellCrash/*\n"
expect "*#"
send "echo 1 | /etc/storage/ShellCrash/menu.sh\n"
expect "*#"
send "exit\n"
expect eof
EOF

    logger "restart successful!"
}

function relogin() {
    logger "rm known_hosts"
    rm -rf ~/.ssh/known_hosts

    logger "re login start"

    /usr/bin/expect <<EOF
set timeout 10
spawn ssh admin@${ip}
expect "yes/no"
send "yes\n;exp_continue"
expect "*assword:"
send "$password\n"
expect "*#"
send "rm -rf /etc/storage/ShellCrash\n"
expect "*#"
send "exit\n"
expect eof
EOF

    logger "re login end"
}

relogin
autoscp
autorestart
