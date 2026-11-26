#!/bin/sh
# Called once a minute from cron. With RTSP_SLEEP_STOP=on it checks the camera sleep flag
# every 10 s and stops v4l2rtspserver soon after the app switches the camera off.
# Starting it again is left to the per-minute watchdog in rtspserver.sh.

HACK_INI=/tmp/hack.ini
[ "$(awk -F "=" '/^RTSP_SLEEP_STOP *=/ {print $2}' $HACK_INI)" = "on" ] || exit 0

for i in 1 2 3 4 5; do
  sleep 10
  if [ -e /atom/configs/.camera_sleep ] && pidof v4l2rtspserver > /dev/null ; then
    killall v4l2rtspserver > /dev/null 2>&1
    echo `date +"%Y/%m/%d %H:%M:%S"` ": camera sleep, v4l2rtspserver stop"
  fi
done
