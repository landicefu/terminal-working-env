function opacity_calc() {
	ruby -e "puts (255*$1/100).round.to_s(16)"
}

function logcat_monitor()
{
	while true; do
		adb wait-for-device
		adb shell logcat -c
		clear
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
	# IFS=$'\r\n' GLOBIGNORE='*' command eval "devices=($(adb devices | grep device | grep -v attached | awk '{print $1}'))"
	adb devices | grep device | grep -v attached | awk '{print $1}'
}

function adbs_select()
{
	# IFS=$'\r\n' GLOBIGNORE='*' command eval "devices=($(adb devices | grep device | grep -v attached | awk '{print $1}'))"
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

function signdebug()
{
	rm -f signed_$1

	java -jar ~/bin/terminal-working-env/signkey/signapk.jar ~/bin/terminal-working-env/signkey/testkeys/platform.x509.pem ~/bin/terminal-working-env/signkey/testkeys/platform.pk8 "$1" "signed_$1"
}

function adb_logcat()
{
	adb shell logcat -c
	adb shell logcat -v time > $(date +%Y-%m-%d_%H-%M-%S)_$1.log
}

function stop_build() {
	ps -A | grep java.*GradleDaemon | grep -v grep | awk '{print $1}' | xargs kill
}

function pull_apk() {
	version_name=$(adb shell dumpsys package $1 | grep versionName | head -n 1 | awk -F '=' '{print $2}' | sed -e $'s/\r//')
	adb pull $(adb shell pm path $1 | sed -e 's/package://' -e $'s/\r//') $1_$version_name.apk
}

function screen_keep_on() {
	echo "Current screen off timeout is $(adb shell settings get system screen_off_timeout)"
	echo "Set screen always on"
	adb shell settings put system screen_off_timeout 2147483647
}

function screen_off_timeout() {
	echo "Current screen off timeout is $(adb shell settings get system screen_off_timeout)"
	echo "Set screen off timeout to $1"
	adb shell settings put system screen_off_timeout $1
}

function install_apk_from() {
	apks_ls=$(ls "$1"/*.apk 2>/dev/null | sed -e '/^\s*$/d')
	if [[ -z $apks_ls ]]; then
		echo "there is no apk file in download directory"
	else
		echo "Please select a apk to install from following files"
		echo "$apks_ls" | awk '{printf "[%d]\t%s\n", NR, $0}'
		read select
		adb install -r $(echo "$apks_ls" | head -n $select | tail -n 1)
	fi
}

function adb_get_version_name() {
	adb shell pm dump $1 | sed -e '/Hidden system packages/,$ d' | grep versionName | sed -e 's/.*=//'
}

