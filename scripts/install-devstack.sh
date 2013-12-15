#!/bin/bash
set +o
set +x

# using  douban source
if [ ! -e $HOME/.pip ];then
mkdir $HOME/.pip
fi

cat <<EOF>$HOME/.pip/pip.conf
[global]
index-url = http://pypi.douban.com/simple/
EOF

# replace source.list
sed -i s/us/cn/g /etc/apt/sources.list
# do update
echo "==>updating..."
apt-get update -y >/dev/nul

echo "==>installing git ..."
# install git
sudo apt-get install git -qqy 
# devstack cannot be run with root now we need to create
# a normal user called stack and grant it sudoer previlige
# to run as root
# add stack user
echo "==> add user stack..."
groupadd stack
useradd -g stack -s /bin/bash -d /opt/stack -m stack

#change to root user
echo "==> su to root user"
sudo -i

#  have sudo priviledges to root without a password
echo "==> grant stack sudo permission without password"
sudo echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#su to stack
echo "==> su to stack user"
su stack
echo "==> cd to /home"
cd /home


echo "clone devstack..."
#clone devstack
sudo git clone https://code.csdn.net/openstack-dev/devstack.git > /dev/nul
#git clone https://github.com/openstack-dev/devstack.git

echo "copy localrc..."
#copy localrc from sync folder
if [ -e /vagrant_data/localrc ]; then
    sudo cp  /vagrant_data/localrc /home/devstack/
fi
echo "==>change owner of devstack to user stack"
sudo chown -R stack:stack /home/devstack
echo "==>verifiing ..."
ls -al /home/devstack
echo "==> checking the current user..."
USER=`whoami`

if [[ $USER -eq "root" ]];then
sudo -i
su stack
NEWUSER=`whoami`
echo "==>current user is $NEWUSER"
fi

echo "==>begin to run devstack please wait..."
cd /home/devstack 
echo "current directory :$PWD"
./stack.sh
echo ===done===
