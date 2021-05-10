#!/usr/bin/env bash

# Must be executed as root cause lvdisplay, pvs commands are used

set -eo pipefail

DEVICE_DISK='sda5'

is_lvm_used(){
	local n="$(/usr/sbin/lvdisplay 2> /dev/null | wc -l || true)"
	if [ "$n" = "0" ]; then
		echo "no"
	else
		echo "yes"
	fi
}

get_mem_usage(){
	echo "$(free -h | grep 'Mem:' | awk '{printf "%s /%s (%.0f%% used)", $3, $2, $3/$2*100}')"
}

get_disk_usage(){
	local result

	if [ "$(is_lvm_used)" = "no" ]; then
		result=$(df -h | grep "/dev/$DEVICE_DISK" | awk '{printf "%s /%s (%s used)", $3, $2, $5}')
	else
		pv=$(/usr/sbin/pvs --units G --options pv_name,pv_used,pv_size \
			| grep mapper | awk '{printf "%s -> %s / %s (%.0f%% used)", $1, $2, $3, $2 /$3 * 100}')
		filesystems=$(lsblk -o 'MOUNTPOINT,FSUSED,FSSIZE,FSUSE%,SIZE,NAME' \
					| grep -e 'LVM' -e NAME | awk '{print "\t"$0}')
		filesystems_ascii=$(echo "$filesystems" | tr -cd '\11\12\15\40-\176')
		result="\n\tPV: $pv\n$filesystems_ascii"
	fi
	echo -e "$result"
}

get_networks(){
	local result=""
	local list_active_interface="$(ip addr | awk '/state UP/ {print $2}')"
	
	i=$(echo "$list_active_interface" | wc -l)
	if [ "$i" = "0" ]; then
		result='#Network: No active interface'
	fi
	while [ $i -gt 0 ]; do
		name="$(echo "$list_active_interface" | sed "${i}q;d")"
		ip="$(ip addr show $name | grep "inet " | awk '{printf "%s", $2}')"
		mac="$(ip addr show $name | grep "link/ether" | awk '{printf "%s", $2}')"
		result=$(echo -ne "$result\n\t$name $ip ($mac)")
		i=$((i - 1))
	done
	echo "$result"
}

get_cpu_usage(){
	local percent
	percent="$(mpstat 1 5 -o JSON \
		| jq -r '[.sysstat.hosts[0].statistics[]."cpu-load"[0].usr] | add / length' \
		| awk '{printf "%.2f", $0}')%"
	echo "$percent"
}

get_report(){
	local report=
	read -r -d '' report <<-EOF || true
	#------------------------------------------------------------------
	#-                         REPORT                                 -
	#------------------------------------------------------------------
	# Architechture: $(uname -a)
	# Physical CPU: $(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
	# Virtual  CPU: $(cat /proc/cpuinfo | grep "^processor" | wc -l)
	# CPU  load: $(get_cpu_usage)
	# Memory usage: $(get_mem_usage)
	# LVM  enabled: $(is_lvm_used)
	# Disk   usage: $(get_disk_usage)
	# User log : $(users | wc -w) users currently logged
	# Last boot: $(who -b | awk '{$1=$1; print}' | cut -d ' ' -f 3-)
	# Connections TCP: $(ss -s | grep estab | awk '{printf "%d ESTABLISHED", $4}')
	# Log sudo : $(ls /var/log/sudo/00/00/ 2> /dev/null | wc -w) commands ($((36#"$(cat /var/log/sudo/seq)")) seq)
	# Active Interfaces:$(get_networks)
	#------------------------------------------------------------------
	EOF

	echo "$report"
}

main(){
	if [ "$(id -u)" != "0" ]; then
		echo "$0 : Error - script must be executed as root"
		exit 1
	fi
	local report="$(get_report)"

	echo "$report" | wall -n
}

main "$@"
