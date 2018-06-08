#!/bin/bash
#
#
#
#
#
# Function Check Distribution and Version
check_distro() {

	arch=$(uname -m)
	kernel=$(uname -r)
	if [ -n "$(command -v lsb_release)" ]; then
		distroname=$(lsb_release -s -d)
	elif [ -f "/etc/os-release" ]; then
		distroname=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="')
	elif [ -f "/etc/debian_version" ]; then
		distroname="Debian $(cat /etc/debian_version)"
	elif [ -f "/etc/redhat-release" ]; then
		distroname=$(cat /etc/redhat-release)
	else
		distroname="$(uname -s) $(uname -r)"
	fi
	
	echo "${distroname}"

}
#
install_epel_7() {
#Install epel repository
#
## RHEL/CentOS 7 64-Bit ##
# wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# rpm -ivh epel-release-latest-7.noarch.rpm 
# Update the system 
yum check-update
# Install the additional package repository EPEL
yum -y install epel-release
}
#
install_epel_6_32b() {
## RHEL/CentOS 6 32-Bit ##
# wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# rpm -ivh epel-release-6-8.noarch.rpm
# rm epel-release-6-8.noarch.rpm
}
#
install_epel_6_64b() {
## RHEL/CentOS 6 64-Bit ##
# wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# rpm -ivh epel-release-6-8.noarch.rpm
# rm epel-release-6-8.noarch.rpm
}
#
# Install extra packages for CentOS 7
install_package_CentOS_7() {
# Update the system 
yum check-update
# Install extra packages
yum -y install perl-TimeDate perl-Time-HiRes perl-Digest-SHA1 perl-Curses perl-Net-Telnet git gcc make perl-Data-Dumper perl-DB_File 
}
#
install_package_debian() {
# Update the system 
apt-get update
# Install extra packages
apt-get -y install libtimedate-perl libnet-telnet-perl libcurses-perl libdigest-sha-perl libdata-dumper-simple-perl
}
#
# Create User and group - Create Directory and Symbolic Link
#
check_if_exist_user() {
egrep -i "^sysop:" /etc/passwd;
if [ $? -eq 0 ]; then
   echo "User Exists no created"
else
   echo "User does not exist -- proceed to create user"
   adduser -m sysop
   fi
}

check_if_exist_group() {
egrep -i "^spider" /etc/group;
if [ $? -eq 0 ]; then
   echo "Group Exists"
else
   echo "Group does not exist -- procced to create group"
   groupadd -g 251 spider	
fi
}

create_user_group() {
# Greate user
check_if_exist_user

# Create group 
check_if_exist_group

# Create symbolic links 
ln -s ~sysop/spider /spider

# Add the users to the spider group
usermod -aG spider sysop
usermod -aG spider root
} 

# Enter CallSign for cluster
 insert_cluster_call{
 echo "Please enter CallSign for DxCluster: "
 read DXCALL
 echo ${DXCALL}
 su - sysop -c "sed -i 's/mycall =.*/mycall = "${DXCALL}";/' /spider/local/DXVars.pm"
}

# Enter your CallSign
insert_call(){
 echo "Please enter your CallSign: "
 read SELFCALL
 echo ${SELFCALL}
 su - sysop -c "sed -i 's/myalias =.*/myalias = "${SELFCALL}";/' /spider/local/DXVars.pm"
}

# Enter your E-mail
insert_email(){
 echo "Please enter your E-mail Address: "
 read EMAIL
 echo ${EMAIL}
 su - sysop -c "sed -i 's/myemail =.*/myemail = "${EMAIL}";/' /spider/local/DXVars.pm"
}



install_app() {
# Download Application dxspider with git
su - sysop -c "git clone git://scm.dxcluster.org/scm/spider"
}

config_app(){
#
# Fix up permissions ( AS THE SYSOP USER )
su - sysop -c "chown -R sysop.spider spider"
su - sysop -c "find . -type d -exec chmod 2775 {} \;"
su - sysop -c "find . -type f -exec chmod 775 {} \;"
# 
su - sysop -c "cd /spider"
su - sysop -c "mkdir -p /spider/local"
su - sysop -c "mkdir -p /spider/local_cmd"
su - sysop -c "cp /spider/perl/DXVars.pm.issue /spider/local/DXVars.pm"
su - sysop -c "cp /spider/perl/Listeners.pm /spider/local/Listeners.pm"
sleep 2
insert_cluster_call
sleep 2
insert_call
sleep 2
insert_email
}


main() {
	create_user_group
	sleep 3
	install_app
	sleep 3
	config_app
}
