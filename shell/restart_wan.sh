set -e

log_file="/tmp/ssh.log"
password=''
ip="192.168.1.1"

echo "" >$log_file

logger() {
    msg=$1
    echo -e "---------------${msg}---------------"
    echo $msg >>$log_file
}

relogin() {
    logger "rm known_hosts"
    rm -rf ~/.ssh/known_hosts
    logger "re login start"
    /usr/bin/expect <<EOF
set timeout 10
spawn ssh admin@${ip}
expect "yes/no"
send "yes\n exp_continue"
expect "*assword:"
send "$password\n"
expect "*#"
send "/sbin/restart_wan\n"
expect "*#"
send "sleep 1\n"
expect "*#"
send "exit\n"
expect eof
EOF

    logger "re login end"
}

relogin
