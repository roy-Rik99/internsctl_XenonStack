#!/bin/bash

#Displays CPU Information
function _help () {
	printf "Usage : internsctl [--version]\n"
	printf "\t\t   [--help]\n"
	printf "\t\t   [cpu getinfo]\n"
	printf "\t\t   [memory getinfo]\n"
	printf "\t\t   [user create USER_NAME]\n"
	printf "\t\t   [user set sudo USER_NAME]\n"
	printf "\t\t   [user list] | [user list  --sudo-only]\n"
	printf "\t\t   [file getinfo <FILENAME>.<EXTENTION>]\n"
	printf "\t\t   [file getinfo {(--size | -s) | (--permissions | -p) | (--owner | -o) | (--last-modified | -m)} <FILENAME>.<EXTENTION>]\n"

	printf "\ninternsctl provides a high-level commandline interface for obtaining information about System Architecture, Resources,\nUsers Accounts and Files, Adding new users to system and Adding existing users to SUDO group.\n"

	printf "\nOPTIONS :\n"

	printf "\n\t--version\n"
	printf "\n\t\tPrints the internsctl version.\n"

	printf "\n\t--help\n"
	printf "\n\t\tPrints the synopsis and a list of the most commonly used commands.\n"

	printf "\n\tcpu getinfo\n"
	printf "\n\t\tDisplays Information about the Central Processing Unit (CPU) in our Server.\n"

	printf "\n\tmemory getinfo\n"
	printf "\n\t\tDisplays Information about Memory in our Server.\n"

	printf "\n\tuser create <login>\n"
	printf "\n\t\tCreates a New Regular User in our Server with a <login> User Name.\n"

	printf "\n\tuser set sudo <login>\n"
	printf "\n\t\tAdds a <login> User in our Server to the SUDO Group.\n"

	printf "\n\tuser list <option>\n"
	printf "\n\t\tIf no <option> is specified, displays all Regular users in the system.\n"

	printf "\n\tuser list --sudo-only\n"
	printf "\n\t\tOnly displays Users in SUDO Group.\n"

	printf "\n\tfile getinfo <options> <filename.extension>\n"
	printf "\n\t\tIf no <options> is specified, displays all information about the <filename.extension>.\n"

	printf "\n\t\t\tfile getinfo {--size, -s} <filename.extension>\n"
	printf "\t\t\t\tOnly displays the Size of the specified file <filename.extension>.\n"

	printf "\n\t\t\tfile getinfo {--permissions, -p} <filename.extension>\n"
	printf "\t\t\t\tOnly displays the Permissions of the specified file <filename.extension>.\n"

	printf "\n\t\t\tfile getinfo {--owner, -o} <filename.extension>\n"
	printf "\t\t\t\tOnly displays the Owner of the specified file <filename.extension>.\n"

	printf "\n\t\t\tfile getinfo {--last-modified, -m} <filename.extension>\n"
	printf "\t\t\t\tOnly displays the Last Modification Time of the specified file <filename.extension>.\n"
}
function cpu_info () {
	echo "*********************CPU Information*********************"
	lscpu
	return 0
}

#Displays Memory Information
function memory_info () {
	echo "*********************Memory Information*********************"
	free
	return 0
}

#Creates a User and sets a password
function user_create () {
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
function convert_sudo () {
	sudo usermod -aG sudo $1
}

#Displays either regular users or sudo users
function user_list () {
	if [ "$1" =  "regular" ]; then
		min=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
		max=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)
		echo "*********************All Users*********************"
		#Uncomment for Displaying all users including Service Accounts
		#getent passwd | cut -d: -f1
		#Uncomment for Displaying all users with USER ID '100?'
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
function file_details () {
	name=`stat --format="%n" $1`
	err=$?
	access=`stat --format="%A" $1`
	size=`stat --format="%s" $1`
	owner=`stat --format="%U" $1`
	lastmod=`stat --format="%y" $1`
	if [ $err -eq 0 ]; then
		if [ "$2" = "--size" -o "$2" = "-s" ]; then
			printf "\nSize(B):\t%s\n\n" "$size"
		elif [ "$2" = "--permissions" -o "$2" = "-p" ]; then
			printf "\nAccess:\t\t%s\n\n" "$access"
		elif [ "$2" = "--owner" -o "$2" = "-o" ]; then
			printf "\nOwner:\t\t%s\n\n" "$owner"
		elif [ "$2" = "--last-modified" -o "$2" = "-m" ]; then
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
