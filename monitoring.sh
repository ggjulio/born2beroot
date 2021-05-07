#!/usr/bin/env bash

# Mush be executed as root cause lvdisplay command used

set -eo pipefail

get_mem_usage(){
	echo $(free -h | grep 'Mem:' | awk '{printf "%s /%s (%.0f%% used)", $3, $2, $3/$2*100}')
}
get_disk_usage(){
	echo $(df -h | grep '/dev/sda2' | awk '{printf "%s /%s (%s used)", $3, $2, $5}')
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

is_lvm_used(){
	n="$(lvdisplay 2> /dev/null | wc -l || true)"
	if [ "$n" = "0" ]; then
		echo "no"
	else
		echo "yes"
	fi
}

get_report(){
	local report=
	read -r -d '' report <<-EOF || true 
	#Architechture: $(uname -a)
	#Physical CPU core: $(nproc)
	#Virtual  CPU core:
	#Memory  usage: $(get_mem_usage)
	#Disk    usage: $(get_disk_usage)
	#CPU  load:
	#Last boot: $(who -b | awk '{printf "%s %s", $3, $4}')
	#User log : $(users | wc -w) users currently logged
	#LVM  use : $(is_lvm_used)
	#Connections TCP: $(ss -s | grep estab | awk '{printf "%d ESTABLISHED", $4}')
	#Total log sudo : $(ls /var/log/sudo/00/00/ | wc -w) commands
	#Active Interfaces:$(get_networks)
	EOF

	echo "$report"
}

main(){
	if [ "$(id -u)" != "0" ]; then
		echo "$0 : Error - script must be executed as root"
		exit 1
	fi
	while [ true ]; do
		echo "$(get_report)"
		exit
		sleep $((5 * 60))
	done
}

main "$@"