#!/bin/sh
pkill -f "single $1"
osascript -e 'display dialog "Touch your YubiKey..." with title "AWS CLI" buttons {"OK"} giving up after 60' >/dev/null 2>&1 &
dialog_pid=$!
otp=$(ykman oath accounts code --single "$1")
kill "${dialog_pid}" 2>/dev/null
echo "${otp}"
