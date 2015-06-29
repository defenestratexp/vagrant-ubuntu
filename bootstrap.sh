#!/usr/bin/env bash

# Epoch time before system updates #
startingepoch=`date +%s`

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
apt-get -y install vim vim-nox htop sysstat nmap lsof telnet tmux unzip pwgen irssi telnet git ssh-askpass

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
apt-get -y install puppet-lint pylint pyflakes lintian jlint linklint nslint weblint-perl libcroco-tools tidy
pip install flake8
pip install pylint
pip install vim-vint
pip install fluff
pip install bashlint
pip install regexlint

# Must install nodejs before using npm to install jslint #
##########################################################
apt-get -y install nodejs
npm install -g jslint

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
useradd -d /home/thompsont -m -s /bin/bash -G admins,adm,vboxuser,vagrant thompsont

# Local sudo Access #
#####################
echo "thompsont ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Extra directories #
#####################
mkdir /home/thompsont/bin
mkdir -p /home/thompsont/build/{repos,src,bin}
mkdir /home/thompsont/tmp

# Create script to install rails #
##################################
echo "#!/bin/bash" > /home/thompsont/bin/getrails.sh
echo "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3" >> /home/thompsont/bin/getrails.sh
echo "curl -sSL https://get.rvm.io | bash -s stable --rails" >> /home/thompsont/bin/getrails.sh
echo "source /home/thompsont/.rvm/scripts/rvm" >>/home/thompsont/bin/getrails.sh

# Create script to install chef client #
########################################
echo "#!/bin/bash" > /home/thompsont/bin/getchef.sh
echo "curl -L https://www.chef.io/chef/install.sh | sudo bash"

chmod +x /home/thompsont/bin/getrails.sh
chmod +x /home/thompsont/bin/getchef.sh
chown -R thompsont:thompsont /home/thompsont

# Execute rails script #
########################
echo "# Attempting to install rails for thompsont #"
echo "#############################################"
echo ""
sudo -H -u thompsont /home/thompsont/bin/getrails.sh

# Execute chef-client script #
##############################
echo "# Attempting to install chef-client for thompsont #"
echo "###################################################"
echo ""
sudo -H -u thompsont /home/tthomspon/bin/getchef.sh

# Copy vimrc #
##############
wget -O /home/thompsont/.vimrc https://www.dropbox.com/s/21z2qquqk0n9py8/vimrcplugins?dl=0
chown thompsont:thompsont /home/thompsont/.vimrc

# Install vim plugins #
#######################
echo "#!/bin/bash" > /home/thompsont/bin/vimplugin
echo "vim +PluginInstall +qall" >> /home/thompsont/bin/vimplugin
chown thompsont:thompsont/home/thompsont/bin/vimplugin
sudo -H -u thompsont /home/thompsont/bin/vimplugin

# Epoch time after last config #
################################
finishepoch=`date +%s`

differenceinseconds=$((startingepoch - finishepoch))
divider=60
packageconfigtime=$((differenceinseconds / divider))
echo "Package configuration took $packageconfigtime minutes"
