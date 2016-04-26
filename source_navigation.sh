# Landice's Working Environment
# Author
#	Landice Fu - landice.fu@gmail.com
#	
# This script provides following commands:
# 1. navigation under a project folder
#	- godir		(go to the path which matches argument as a regular expression)
#	- croot		(go to the project root)
#
# 2. navigation to saved path alias
#	- lsp <alias>	(save current path to alias list with name <alias>)
#	- ldp <alias>	(delete a saved path alias from environment)
#	- llp <alias>	(load a saved path alias)
#	- llp slist <alias_list_name>	(save the current alias list to a list file somewhere you can load)
#	- llp dlist <alias_list_name>	(delete the alias list)
#	- llp llist <alias_list_name>	(load the alias list)
#	- llp lslist			(list all the alias list you can load)
#	note that lsp and llp "without argument" can be used to save to a default path for convenience

esc=`echo -en "\033"`
	# Colors
	Red="${esc}[0;31m"
	Green="${esc}[0;32m"
	Yellow="${esc}[0;33m"
	Blue="${esc}[0;34m"
	Reset="${esc}[0m"

# This piece of code is extracted from the build script of Android Open Source Project (AOSP).
# I found it extremely useful when you have to navigate between different folders in a large project.
# However, the original code can be only used in AOSP source folders.
# I made some changes to the functions so that it can be used anywhere you want
#
# How to use:
# 1. 	Navigate to the root folder of the project files
# 2. 	execute command "godir"
# 3.	Since it's the first time you use this command, it will build a file named .filelist to index all the source files in this root folder
# 4.	After the index file is built, you can use the same expression to go somewhere
#	that contains filename include LocationManager.java, by executing "godir LocationManager"
#	The parameter can be regular expression including folder name like "godir lifehackers/.*/MainActivity"
function godir () {
	T=$(gettop)
	if [[ ! -f $T/.filelist ]]; then
		echo -n "Press any key to generate index in this folder..."
		read -p "$*"
		T=$(pwd)
		echo -n "Creating index..."
		(find . -not -regex '.*/\..*\|.*.swp' -type f > .filelist)
		echo " Done"
		echo ""
	fi

	if [[ -z "$1" ]]; then
		echo "${Red}Usage: ${Yellow}godir ${Green}<regex>${Reset}"
		return
	fi

	local lines
	lines=($(\grep "$1" "$T/.filelist" | sed -e 's/\/[^/]*$//' | sort | uniq))
	if [[ ${#lines[@]} = 0 ]]; then
		echo "Not found"
		return
	fi

	local pathname
	local choice

	# Check if there is -l option (used to list matched files)
	local if_list=0
	for var in "$@"; do
		if [ "$var" == "-l" ]; then
			if_list=1
		fi        
	done


	if [[ ${#lines[@]} > 1 ]]; then
		while [[ -z "$pathname" ]]; do
			local index=1
			local line
			for line in ${lines[@]}; do
				# print all folders with matched files
				printf "%6s %s\n" "[$index]" $line
				# if there is option -l then print all matched files under the directory
				if [ $if_list -eq 1 ]; then
					matched_files=($(\ls $T/$line/*$1* | sed -e 's/.*\///'))
					for matched_file in ${matched_files[@]}; do
						printf "\t%s\n" $matched_file
					done
				fi
				index=$(($index + 1))
			done
			echo
			echo -n "Select one: "
			unset choice
			read choice
			if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
				echo "Invalid choice"
				continue
			fi
			pathname=${lines[$(($choice-1))]}
		done
	else
		pathname=${lines[0]}
	fi
	cd "$T/$pathname"
}

# When "croot" is executed, it searches its parent folders for .filelist, and change working directory back to the project root
# This function only works when your are in a project folder, where there is a .filelist included.
# Therefore, be sure to run godir to create a file index in the source root before using this command
function croot() {
	T=$(gettop)
	if [[ -f "$T/.filelist" ]]; then
		cd "$T"
	else
		echo "${Red}Cannot find the index file!"
		echo "Please be sure to create index file by executing godir at source root.${Reset}"
	fi
}

function gettop() {
	local TOPFILE=".filelist"
	if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
		echo "$TOP"
	else
		if [ -f "$TOPFILE" ] ; then
			# The following circumlocution (repeated below as well) ensures
			# that we record the true directory name and not one that is
			# faked up with symlink names.
			PWD= /bin/pwd
		else
			# We redirect cd to /dev/null in case it's aliased to
			# a command that prints something as a side-effect
			# (like pushd)
			local HERE=$(pwd)
			T=
			while [ \( ! \( -f "$TOPFILE" \) \) -a \( "$PWD" != "/" \) ]; do
				cd .. > /dev/null
				T=`PWD= /bin/pwd`
			done
			cd "$HERE" > /dev/null
			if [ -f "$T/$TOPFILE" ]; then
				echo "$T"
			fi
		fi
	fi
}

function lsp()
{
	if [[ -z "$1" ]]; then
		echo "${Green}Save current path to default saved path${Reset}"
		export path_list="$(pwd)"
	else
		echo "${Green}Save current path to saved path[$1]${Reset}"
		export path_list_$1="$(pwd)"
	fi

}

function ldp()
{
	if [[ -z "$1" ]]; then
		echo "${Red}Please specify the path alias you want to delete!${Reset}"
	else
		unset path_list_$1
	fi
}

function llp()
{
	if [[ -z "$1" ]]; then
		if [[ -z "${path_list}" ]]; then
			echo "${Red}Error! No default path saved${Reset}"
		else
			echo "${Green}Going to default saved path: ${Yellow}${path_list}${Reset}"
			export path_list_last="$(pwd)"
			cd ${path_list['default']}
		fi
	elif [[ $1 == "list" ]]; then
		env | grep path_list_ | sed -e "s/path_list_//g" | grep --color .*=
	elif [[ $1 == "slist" ]]; then
		tmp_folder_chk=`find ~/. -maxdepth 1 -type d -name ".path_alias"`
		if [ ! -n "${tmp_folder_chk}" ]; then
			echo "folder ~/.path_alias created"
			mkdir ~/.path_alias
		fi
		export | grep path_list_ | sed -e 's/declare -x /export /g' > ~/.path_alias/saved_path_list_$2
	elif [[ $1 == "llist" ]]; then
		source ~/.path_alias/saved_path_list_$2
	elif [[ $1 == "dlist" ]]; then
		rm ~/.path_alias/saved_path_list_$2
	elif [[ $1 == "lslist" ]]; then
		ls ~/.path_alias/saved_path_list_* | sed -e 's/.*saved_path_list_//g'
	else #there is path parameter
		identifier="path_list_$1"
		echo "${!identifier}"
		if [[ -z "${!identifier}" ]]; then
			echo "${Red}Error! No path tag ${Yellow}$1 ${Red}saved!${Reset}"
		else
			echo "${Green}Going to saved path[$1]: ${Yellow}${!identifier}${Reset}"
			previous_path="$(pwd)"
			cd "${!identifier}"
			export path_list_last=${previous_path}
		fi
	fi
}