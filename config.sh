#!/bin/bash

#Displays CPU Information
function cpu_info {
	echo "*********************CPU Information*********************"
	lscpu
	return 0
}

#Displays Memory Information
function memory_info {
	echo "*********************Memory Information*********************"
	free
	return 0
}

#Creates a User and sets a password
function user_create {
	sudo useradd -m -s /bin/bash $1
	if [ $? -eq 9 ]; then
		printf "\n"
		read -p "Change Password?(y/n)" -s chpwd
		if [ "$chpwd" = "y" -o "$chpwd" = "Y" -o "$chpwd" = "yes" -o "$chpwd" = "Yes" ]; then
			printf "\n\nSet Password for Existing USER %s :-\n\n" "$1"
			sudo passwd $1
		else
			printf "\n"
			return 1
		fi
	else
		printf "\n\nSet Password for New USER %s :-\n\n" "$1"
		sudo passwd $1
	fi
	return 0
}

#Assigns specified user to SUDO group
function convert_sudo {
	sudo usermod -aG sudo $1
}

#Displays either regular users or sudo users
function user_list {
	if [ "$1" =  "regular" ]; then
		min=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
		max=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)
		echo "*********************Regular Users*********************"
		#Uncomment for Displaying all users including Service Accounts
		#getent passwd | cut -d: -f1
		#Uncomment for Displaying all users with USER ID '100.'
		#getent passwd | cut -d: -f1,3 | grep '100.' | cut -d: -f1
		eval getent passwd {$min..$max} | cut -d: -f1
	elif [ "$1" = "sudo" ]; then
		echo "*********************Users with SUDO permissions*********************"
		getent group sudo | cut -d: -f4
	else
		return 1
	fi
	return 0
}

#Displays File Information
function file_details {
	name=`stat --format="%n" $1`
	err=$?
	access=`stat --format="%A" $1`
	size=`stat --format="%s" $1`
	owner=`stat --format="%U" $1`
	lastmod=`stat --format="%y" $1`
	if [ $err -eq 0 ]; then
		if [ "$2" = "size" ]; then
			printf "\nSize(B):\t%s\n\n" "$size"
		elif [ "$2" = "perm" ]; then
			printf "\nAccess:\t\t%s\n\n" "$access"
		elif [ "$2" = "owner" ]; then
			printf "\nOwner:\t\t%s\n\n" "$owner"
		elif [ "$2" = "lastmd" ]; then
			printf "\nModify:\t\t%s\n\n" "$lastmod"
		elif [ "$2" = "all" ]; then
			printf "\nFile:\t\t%s\nAccess:\t\t%s\nSize(B):\t%d\nOwner:\t\t%s\nModify:\t\t%s\n\n" "$name" "$access" $size "$owner" "$lastmod"
		else
			printf "\nInvalid Option!\n\n"
		fi
	else
		return 1
	fi
	return 0
}
