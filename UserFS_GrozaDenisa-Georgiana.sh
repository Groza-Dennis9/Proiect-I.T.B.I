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

	sleep 30
done
