#!/bin/bash

ROOT_DIR="users_logged"
mkdir -p "$ROOT_DIR"

while true;
do
	if [ ! -d "$ROOT_DIR" ]; then
		mkdir "$ROOT_DIR"
	fi
	current_users=$(who | cut -d' ' -f1 | sort -u)
	for user in $current_users;
	do
		user_dir="$ROOT_DIR/$user"
		mkdir -p "$user_dir"
		ps -u "$user" -o pid,comm --no-headers > "$user_dir/procs"
		rm -f "$user_dir/lastlogin"	
	done
	for dir in "$ROOT_DIR"/*;
	do
		username=$(basename "$dir")
		if ! echo "$current_users" | grep -qx "$username"; then
			echo ' ' > "$dir/procs"
			if [ ! -f "$dir/lastlogin" ]; then
				echo "Last updated: " > "$dir/lastlogin" 
				date +"%A %B %d %Y %T" >> "$dir/lastlogin"
			fi
		fi
	done

	sleep 30
done
