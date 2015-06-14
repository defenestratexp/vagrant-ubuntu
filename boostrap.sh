#!/usr/bin/env bash

# Set the install directory #
#############################
workingdir=`pwd`

# Add additional repositories #
###############################

# System Update #
#################

echo "# Will now perform a system update #"
echo "####################################"
echo ""
apt-get -y update

# Install python-pip #
######################
echo "# Installing python-pip #"
echo "#########################"
echo ""
apt-get -y install python-pip

# Install ipython #
###################
echo "# Installing Ipython #"
echo "######################"
echo ""
apt-get -y install ipython

# Install awscli #
##################
echo "# Installing awscli #"
echo "#####################"
echo ""
pip install awscli

# Install java #
################
echo "# Installing OpenJDK #"
echo "######################"
echo ""
apt-get -y install openjdk-7-jre

# Install additional sysadmin tools #
#####################################
echo "# Installing sysadmin tools #"
echo "#############################"
apt-get -y install vim htop sysstat nmap lsof telnet tmux unzip pwgen irssi telnet git ssh-askpass

# Install mysql-client #
##################
echo "# MySQL Client Installation #"
echo "#############################"
echo ""
apt-get -y install mysql-client

# Install nginx #
#################
echo "# nginx Installation #"
echo "######################"
echo ""
apt-get -y install nginx

# Install lint tools #
######################
echo "# Installing lint checkers #"
echo "############################"
echo ""
apt-get -y install puppet-lint pylint pyflakes lintian jlint linklint nslint weblint-perl

# Create a non-vagrant user #
#############################
echo "# Will run useradd to create a non-vagrant user #"
echo "#################################################"
echo ""

# Groups #
##########
groupadd -f admins 
groupadd -f adm 
groupadd -f vboxuser 

# my user #
###########
useradd -d /home/tthompson -m -s /bin/bash -G admins,adm,vboxuser tthompson

# Local sudo Access #
#####################
echo "tthompson ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Extra directories #
#####################
mkdir /home/tthompson/bin
mkdir -p /home/tthompson/build/{repos,src,bin}
mkdir /home/tthompson/tmp

# Create script to install rails #
##################################
echo "#!/bin/bash" > /home/tthompson/bin/getrails.sh
echo "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3" >> /home/tthompson/bin/getrails.sh
echo "curl -sSL https://get.rvm.io | bash -s stable --rails" >> /home/tthompson/bin/getrails.sh
echo "source /home/tthompson/.rvm/scripts/rvm" >>/home/tthompson/bin/getrails.sh

# Create script to install chef client #
########################################
echo "#!/bin/bash" > /home/tthompson/bin/getchef.sh
echo "curl -L https://www.chef.io/chef/install.sh | sudo bash"

chmod +x /home/tthompson/bin/getrails.sh
chmod +x /home/tthompson/bin/getchef.sh
chown -R tthompson:tthompson /home/tthompson

# Execute rails script #
########################
echo "# Attempting to install rails for tthompson #"
echo "#############################################"
echo ""
sudo -H -u tthompson /home/tthompson/bin/getrails.sh

# Execute chef-client script #
##############################
echo "# Attempting to install chef-client for tthompson #"
echo "###################################################"
echo ""
sudo -H -u tthompson /home/tthomspon/bin/getchef.sh

# Copy vimrc #
wget -O /home/tthompson/.vimrc https://www.dropbox.com/s/68d805d40bq517p/vimrc.txt?dl=0
chown tthompson:tthompson /home/tthompson/.vimrc
