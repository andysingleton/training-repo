
#########################################################################
#
# Red Hat Academy Classroom Server Kickstart Script
#
# $Id: 010_text.dbk,v 1.5 2005/08/08 08:35:41 bowe Exp $
# version: RHEL4
# academy-docs@redhat.com
#
# For more information, see the Red Hat Customization Guide, 
# http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/sysadmin-guide/ch-kickstart2.html
#
#########################################################################

###############################################################
# you definately want to set one of the following
###############################################################

rootpw redhat
bootloader --location=mbr --password=redhat

###########################################################################
#
# the following MD5 encrypted passwords can be generated using
#
#    openssl passwd -1 redhat
#
#  see "man sslpasswd" for more information
#
###########################################################################
#rootpw --isencrypted $1$Su2Gv/$fZeEi7RtQq/RAZ1oEla5z0 # md5 encrypted "redhat"
#bootloader --location=mbr --md5pass=$1$x.3x1cDe$ucwc8hTScWzfb5DYW6r25/


###############################################################
# point to a local installation server, or use "cdrom"
###############################################################
text		# you're not going to be standing there watching it, are you?
cdrom
# url --url http://kickstart.example.com/pub/es4/i386


###############################################################
# partitioning
###############################################################
zerombr yes
clearpart --all --initlabel 
part /boot --fstype ext3 --size 128 
part / --fstype ext3 --size 4096 --grow --maxsize 8192
part /var --fstype ext3 --size 4096 --grow --maxsize 8192 
part swap --recommended 

###############################################################
# network configuration
#   - the following is for the "recommended solution" outlined
#     in the Red Hat Academy Instructor's Guide
###############################################################
network --bootproto=static --ip=192.168.0.254 --netmask=255.255.255.0 --device=eth0
network --bootproto=dhcp --device=eth1
#firewall --enabled --http --ftp --port=https:tcp --port=ipp:tcp
firewall --disabled


###############################################################
# environment 
###############################################################
lang en_US
langsupport --default=en_US
timezone America/New_York
#timezone America/Chicago
#timezone America/Denver
#timezone America/Los_Angeles

###############################################################
# hardware 
###############################################################
mouse generic3ps/2
#mouse genericps/2 --emulthree   	# enable for 2 button mice
keyboard us
xconfig --depth=16 --resolution=1024x768 --defaultdesktop=GNOME --startxonboot


###############################################################
# misc
###############################################################
auth  --useshadow  --enablemd5 
reboot					# reboot automatically when done
install					# instead of "upgrade"

###############################################################
#
# New in RHEL-4: SELinux
#
###############################################################
selinux --enforcing
#selinux --permissive
#selinux --disabled

###############################################################
#
# Software
#
###############################################################
%packages --resolvedeps
@ Workstation Common
@ Server
@ GNOME 

@ Engineering and Scientific
@ Games and Entertainment
@ Mail Server
@ DNS Name Server
@ FTP Server
@ Network Servers
@ Development Tools
@ System Tools

ypserv
dhcp
ethereal-gnome
sysstat
vlock

%post
###############################################################
#
# Post Script - the following script runs on the newly
# installed machine, immediately after installation
#
###############################################################

# Assumption: We have puppet installed as part of the server build

# Create the facts.d directory
mkdir -p /etc/facter/facts.d

# Add an environment fact
echo "environment: core-prod" >> /etc/facter/facts.d/base.yaml
echo "role: webserver" >> /etc/facter/facts.d/base.yaml

# Run against the cname of puppet - From here we will configure from the master
puppet agent -t --server puppet --onetime
