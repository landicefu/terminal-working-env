function logcat_monitor()
{
	while true; do
		clear
		adb wait-for-device
		if [[ $i == ${@: -1} ]]; then
			adb shell logcat -v time
		else
			adb shell logcat -v time -s $1
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
	package_name=$(find . -name 'AndroidManifest.xml' | xargs grep package | sed -e 's/.*package=\"//' -e 's/\".*//')
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
