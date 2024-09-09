#!/bin/sh
osascript -e 'tell app "System Events" to display alert "AWS CLI" message "Touch your YubiKey" as critical' >/dev/null 2>&1 &
otp=$(ykman oath accounts code --single "$1")
osascript -e 'tell app "System Events" to tell process "System Events" to click button "OK" of window 1' >/dev/null 2>&1
echo "${otp}"
