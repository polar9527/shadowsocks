# http://elrepo.org/tiki/kernel-ml
uname -r
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
rpm -qa | grep kernel

# check
grub2-editenv list

awk -F \' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
# choose the number of "CentOS Linux (4.13.12-1.el7.elrepo.x86_64) 7 (Core)"
grub2-set-default $number

# check again
grub2-editenv list

shutdown -r now


# check kernel， should be "4.13.12-1.el7.elrepo.x86_64"
uname -r

# yum update
# yum clean all
# yum makecache
# yum groupinstall 'Development Tools'
# yum install python-setuptools python-setuptools-devel vim
# yum install zlib-devel bzip2-devel openssl-devel ncurese-devel
# easy_install pip

yum update
yum clean all
yum makecache
yum -y install epel-release
yum -y install python-pip
yum clean all

pip install shadowsocks

vim /root/shadowsocks.json
{
  "server":"${your server\'s IPv4}",
  "port_password":{
    "${port_1}":"${password_1}",
    "${port_2}":"${password_2}",
    "${port_3}":"${password_3}",
    "${port_4}":"${password_4}"
    },
  "timeout":300,
  "method":"aes-256-cfb",
  "fast_open": true,
  "workers":4
}

firewall-cmd --zone=public --add-port=${port_1}/tcp --permanent
firewall-cmd --zone=public --add-port=${port_2}/tcp --permanent
firewall-cmd --zone=public --add-port=${port_3}/tcp --permanent
firewall-cmd --zone=public --add-port=${port_4}/tcp --permanent
firewall-cmd --reload

vim /etc/rc.local
ssserver -c /etc/shadowsocks.json -d start
echo 3 > /proc/sys/net/ipv4/tcp_fastopen

vim /etc/sysctl.conf
net.ipv4.tcp_fastopen = 3
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl -n net.ipv4.tcp_congestion_control

# should be "tcp_bbr "
lsmod | grep bbr
ssserver -c /root/shadowsocks.json -d start
