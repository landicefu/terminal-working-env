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
