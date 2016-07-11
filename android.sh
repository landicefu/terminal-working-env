function logcat_monitor()
{
	while true; do
		clear
		adb wait-for-device
		if [[ $i == ${@: -1} ]]; then
			adb shell logcat -v time
		else
			adb shell logcat -v time -s $@
		fi
	done
}

function clear_package_data()
{
	echo ${Red}Package Name: ${Yellow}$1${Reset}
	echo ${Red}Clearing package data...${Reset}
	adb shell  pm clear $1
}

function get_studio_package()
{
	temp_path=$(pwd)
	croot
	cd app/src/
	package_name=$(find . -path ./androidTest -prune -o -name 'AndroidManifest.xml' -print | xargs grep package | sed -e 's/.*package=\"//' -e 's/\".*//')
	cd "$temp_path"
	echo $package_name
}

function clear_studio_package()
{
	clear_package_data $(get_studio_package)
}

function uninstall_studio_package()
{
	adb shell pm uninstall $(get_studio_package)
}

function adbs_device_ids()
{
	adb devices | grep device | grep -v attached | awk '{print $1}'
}

function adbs_select()
{
	devices=$(adbs_device_ids)
	num_device=$(echo $devices | wc -l | sed -e 's/^[[:space:]]*//')

	case "$num_device" in
		0)	echo "There is no device to be selected"
			rm ~/.tmp/adbs_selected
			;;
		1)	echo $devices > ~/.tmp/adbs_selected
			;;
		*)	echo "There are more than two devices:"
			echo $devices
			;;
	esac

}

function fill_external_storage()
{
	avail=$(adb shell df | grep \/data | awk '{print $4}')
	i=$((${#avail}-1))
	unit="${avail:$i:1}"
	value="${avail:0:i}"

	if [ "$unit" == "G" ]; then
		bytes=$(echo "$value*1024*1024*1024" | bc)
	elif [ "$unit" == "M" ]; then
		bytes=$(echo "$value*1024*1024" | bc)
	elif [ "$unit" == "K" ]; then
		bytes=$(echo "$value*1024" | bc)
	fi

	bytes=$(printf %.0f $(echo "$bytes"))

	if [ "$bytes" -gt "1073741824" ]; then
		gb_count=$(echo "$(printf %.0f $(echo "$bytes/1073741824" | bc))-1" | bc)
		echo $gb_count
	fi
	
}

