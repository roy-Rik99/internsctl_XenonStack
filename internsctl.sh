#!/bin/bash
source config.sh

#Driver
function internsctl () {
	if [ "$*" = "--version" ]; then
		echo "v0.1.0"
	elif [ "$*" = "cpu getinfo" ]; then
		cpu_info
	elif [ "$*" = "memory getinfo" ]; then
		memory_info
	elif [ "$1 $2" = "user create" ]; then
		user_create "$3"
	elif [ "$1 $2 $3" = "user set sudo" ]; then
		convert_sudo "$4"
	elif [ "$*" = "user list" ]; then
		user_list regular
	elif [ "$*" = "user list --sudo-only" ]; then
		user_list sudo
	elif [ "$1 $2" = "file getinfo" ]; then
		if [[ -z "$4" ]]; then
			if [[ "$3" == *"."* ]]; then
				file_details "$3" "all"
			else
				echo "No File Specified"
			fi
		elif [[ "$4" == *"."* ]]; then
			if [ "$3" = "--size" -o "$3" = "-s" ]; then
				file_details "$4" "size"
			elif [ "$3" = "--permissions" -o "$3" = "-p" ]; then
				file_details "$4" "perm"
			elif [ "$3" = "--owner" -o "$3" = "-o" ]; then
				file_details "$4" "owner"
			elif [ "$3" = "--last-modified" -o "$3" = "-m" ]; then
				file_details "$4" "lastmd"
			else
				echo "Invalid Option"
			fi
		else
			echo "Invalid Syntax."
			echo "Specify file with extension. Eg :- internsctl file getinfo [options] <filename>.<extension>"
		fi
	else
		echo "Wrong Command"
	fi
}
