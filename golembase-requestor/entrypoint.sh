#!/bin/sh
yagna service run &
/usr/src/app/repeat_script.sh &
wait