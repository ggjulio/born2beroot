 1.1.1.1, 8.8.8.8, 8.8.4.4
### credentials
- partition encryption: qwerty
- user unix:
	- root: qwerty
	- juligonz: qwerty
	- user1: 1Aa2021_42

- mysql users:
	- root: qwerty 
	- wordpress: wordpress

- wordpress users:
	- juligonz: 2g!lWVnvfWF7*VWe36

### Todo

- [ ] change ALL PASSWORDS MORON !
- [x] 2 encrypted partitions root and home
	- [x] or bonus...
- [x] AppArmor must run at startup 
- [x] ssh on port 4242
	- [x] root disabled via ssh
	- [x] open firewall port (using firewall UFW)
		- [x] Firewall must run at startup 
- [x] set hostname to "juligonz42"
- [x] password policy -> /etc/login.defs + /etc/pam.d/common-password
	- [x] password expire every 30 days
	- [x] must be at least 10 characters long.
	- [x] must contain an uppercase letter and a number. 
	- [x] must not contain more than 3 consecutives identical characters
	- [x] must not include the name of the user.
	- [x] password must have 7 characters that are not in the old password
	- [x] minimum number of days before modification set to 2 days
	- [x] user need to a warning 7 days before password expires.
	- [x] root password has to comply with this policy too.
- [x] install sudo following strict rules.
	- [x] set up 3 attempts  
	- [x] set up custom message when wrong password
	- [x] TTY mode need to be enabled
	- [x] each action using sudo must be archived
		- [x] both inputs and outputs
		- [x] saved in /var/log/sudo/
	- [x] All paths used by sudo must be restricted. Examples :
		- [x] /usr/local/sbin
		- [x] /usr/local/bin
		- [x] /usr/sbin
		- [x] /usr/bin
		- [x] /sbin
		- [x] /bin
- [x] add a user with my login as username
	- [x] This user nedd to belong to both groups: user42 + sudo
- [x] Create a simple script `monitoring.sh` in bash
	- [x] At startup: output few infos  every 5min (look at wall).
		- [x] No error must be visible
	- [x] must always display:
		- [x] Architecture of OS + kernel version
		- [x] Number of physical core
		- [x] Number of virtual core
		- [x] Available RAM and utilisation rate in %
		- [x] Available memory and utilisation rate in %
		- [x] Processors utilisation rate in %
		- [x] Date and time of last reboot
		- [x] LVM is active or not
		- [x] Number of active connections
		- [x] Number of users using the server
		- [x] IPv4 and MAC address of the server
		- [x] Number of commands executed with sudo program
	- [x] You will also have to interrupt it without modifying it.		
	- [x] Have a look at cron

### Bonus part 
- [x] set up partitions with separation: / , home, var, srv, tmp, var/log
	- [x] ALL ENCRYPTED and of type lvm
- [x] Set up functionnal wordpress using lighttpd, mariaDB, and php
- [x] set up a service of our choice (nginx, apache2 excluded)
	- [x] service dns 

### ref
- https://techencyclopedia.wordpress.com/2020/04/21/debian-10-manual-partition-for-boot-swap-root-home-tmp-srv-var-var-mail-var-log/
- https://www.debian.org/doc/manuals/securing-debian-manual/ch04s11.en.html
- https://wiki.debian.org/sudo
- https://www.tecmint.com/sudoers-configurations-for-setting-sudo-in-linux/
- https://stackoverflow.com/questions/12973777/how-to-run-a-shell-script-at-startup
- https://stackoverflow.com/questions/1332861/how-can-i-determine-the-current-cpu-utilization-from-the-shell
- https://www.linuxhowtos.org/System/procstat.htm
- https://rosettacode.org/wiki/Linux_CPU_utilization
- https://www.datacenters.com/news/what-is-a-vcpu-and-how-do-you-calculate-vcpu-to-cpu
- https://crontab.guru/tips.html
- https://doc.ubuntu-fr.org/cron
- https://myshell.co.uk/blog/2012/07/how-to-determine-the-number-of-physical-cpus-on-linux/
- https://stackoverflow.com/questions/4270280/linux-and-physical-and-virtual-cpus
- https://doc.ubuntu-fr.org/bind9
- https://catalin.works/blog/bind9-dns-setup-local-domain-names/#configuring-bind-9
- https://www.installerunserveur.com/configuration-bind9
- https://debian-facile.org/atelier:chantier:dns-bind9-sur-wheezy
- https://www.debian.org/doc/manuals/securing-debian-manual/ch04s11.en.html
- https://debian-facile.org/doc:securite:passwd:libpam-pwquality
- http://shekel.jct.ac.il/~roman/linux/pam/pam-list.html

### wall: cannot get tty name: Inappropriate ioctl for device (cat /etc/mail/login)
- https://bugzilla.redhat.com/show_bug.cgi?id=1608176
- https://forums.fedoraforum.org/showthread.php?303093-upsmon-wall-cannot-get-tty-name
- https://serverfault.com/questions/814769/how-to-silently-broadcast-a-warning-from-a-cronjob-via-wall
### visudo:
 authfail_message
 badpass_message
 iolog_dir ???
 iolog_file

PB:
- vcpu
- add seq to sudo count ! (maxseq...)