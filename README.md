### Todo

- [x] 2 encrypted partitions root and home
	- [x] or bonus...
- [ ] AppArmor must run at startup 
- [x] ssh on port 4242
	- [x] root disabled via ssh
	- [x] open firewall port (using firewall UFW)
		- [x] Firewall must run at startup 
- [x] set hostname to "juligonz42"
- [ ] set up password policy
	- [ ] password expire every 30 days
	- [ ] must be at least 10 characters long.
	- [ ] must contain an uppercase letter and a number. 
	- [ ] must not contain more than 3 identical characters
	- [ ] must not include the name of the user.
	- [ ] password must not contain more than 3 characters identical to the ones of the former password
	- [ ] minimum number of days before modification set to 2 days
	- [ ] user need to a warning 7 days before password expires.
	- [ ] root password has to comply with this policy too.
- [ ] install sudo following strict rules.
	- [x] set up 3 attempts  
	- [x] set up custom message when wrong password
	- [ ] each action using sudo must be archived
		- [ ] both inputs and outputs
		- [ ] saved in /var/log/sudo/
- [x] add a user with my login as username
	- [x] This user nedd to belong to both groups: user42 + sudo
- [ ] TTY mode need to be enabled
- [ ] All paths used by sudo must be restricted. Examples :
	- [ ] /usr/local/sbin
	- [ ] /usr/local/bin
	- [ ] /usr/sbin
	- [ ] /usr/bin
	- [ ] /sbin
	- [ ] /bin
	- [ ] /snap/bin
- [ ] Create a simple script `monitoring.sh` in bash
	- [ ] At startup: output few infos  every 5min (look at wall).
		- [ ] No error must be visible
	- [ ] must always display:
		- [ ] Architecture of OS + kernel version
		- [ ] Number of physical core
		- [ ] Number of virtual core
		- [ ] Available RAM and utilisation rate in %
		- [ ] Available memory and utilisation rate in %
		- [ ] Processors utilisation rate in %
		- [ ] Date and time of last reboot
		- [ ] LVM is active or not
		- [ ] Number of active connections
		- [ ] Number of users using the server
		- [ ] IPv4 and MAC address of the server
		- [ ] Number of commands executed with sudo program
	- [ ] You will also have to interrupt it without modifying it.		- [ ] Have a look at cron

### Bonus part 
- [x] set up partitions with separation: / , home, var, srv, tmp, var/log
	- [x] ALL ENCRYPTED and of type lvm
- [ ] Set up functionnal wordpress using lighttpd, mariaDB, and php
- [ ] set up a service of our choice (nginx, apache2 excluded)


### password policy conf /etc/login.defs

PASS_MAX_DAYS	30


- https://techencyclopedia.wordpress.com/2020/04/21/debian-10-manual-partition-for-boot-swap-root-home-tmp-srv-var-var-mail-var-log/
- https://www.debian.org/doc/manuals/securing-debian-manual/ch04s11.en.html
- https://wiki.debian.org/sudo
- https://www.tecmint.com/sudoers-configurations-for-setting-sudo-in-linux/

### visudo:
 authfail_message
 badpass_message
 iolog_dir ???
 iolog_file
