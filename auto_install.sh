#!/bin/bash
set -e
#set +x #打开调试

user="$(id -un 2>/dev/null || true)"
sh_c='sh -c'
if [ "$user" != 'root' ]; then
        if command_exists sudo; then
                sh_c='sudo -E sh -c'
        elif command_exists su; then
                sh_c='su -c'
        else
                cat >&2 <<-'EOF'
                Error: this installer needs the ability to run commands as root.
                We are unable to find either "sudo" or "su" available to make this happen.
                EOF
                exit 1
        fi
fi


command_exists() {
        command -v "$@" > /dev/null 2>&1
}


#SYS=$(lsb_release -i | cut -f 2-)
get_distribution() {
        lsb_dist=""
        # Every system that we officially support has /etc/os-release
        if [ -r /etc/os-release ]; then
                lsb_dist="$(. /etc/os-release && echo "$ID")"
        fi
        # Returning an empty string here should be alright since the
        # case statements don't act unless you provide an actual value
        echo "$lsb_dist"
}


#if echo "$lsb_dist" | grep -q "ubuntu" || echo "$lsb_dist" | grep -q "debian"; then
#       $sh_c "apt-get install -y git >/dev/null"
#elif echo "$lsb_dist" | grep -q "centos"; then
#       $sh_c "yum install -y  git >/dev/null"
#fi



$sh_c "mkdir /home2/ >/dev/null"
$sh_c "cd /home2 >/dev/null"

$sh_c "sudo systemctl enable docker"
$sh_c "sudo systemctl start docker"
$sh_c "docker pull registry.cn-hangzhou.aliyuncs.com/ryynet/php5.6:1.0"
$sh_c "docker pull registry.cn-hangzhou.aliyuncs.com/ryynet/django-1.11.7:1.0"
$sh_c "sudo mkdir -p /etc/docker"
$sh_c "sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://y332lds0.mirror.aliyuncs.com"]
}
EOF"
$sh_c "sudo systemctl daemon-reload"
$sh_c "sudo systemctl restart docker"
$sh_c "git clone https://github.com/bruce994/ryynet_docker.git"

