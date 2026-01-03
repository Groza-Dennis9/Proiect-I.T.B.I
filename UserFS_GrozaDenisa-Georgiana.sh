#!/bin/bash

ROOT_DIR="users_logged"
cd
mkdir -p "$ROOT_DIR"

while true;
do
	current_users=$(who | cut -d' ' -f1)
	for user in $current_users;
	do
		user_dir="$ROOT_DIR/$user"
		mkdir -p "$user_dir"
		ps -u "$user" -o pid,command --no-headers > "$user_dir/procs"
		rm -f "$user_dir/lastlogin"	
	done
	for dir in "$ROOT_DIR"/*;
	do
		username=$(basename "$dir")
		if ! echo "$current_users" | grep -qx "$username"; then
			echo ' ' > "$dir/procs"
			if [ ! -f "$dir/lastlogin" ]; then
				last -R "$username" | awk '/gone - no logout/' | head -n -1|  cut -d' ' -f14-18 > "$dir/lastlogin"
				echo "Last updated: " >> "$dir/lastlogin" 
				date >> "$dir/lastlogin"
			fi
		fi
	done

	sleep 30
done
