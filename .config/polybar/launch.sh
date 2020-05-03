#!/usr/bin/env bash

killall -q polybar

echo '----------' | tee -a /tmp/polybar-main.log

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main >>/tmp/polybar-main.log 2>&1 &
  done
else
  polybar --reload main >>/tmp/polybar-main.log 2>&1 &
fi

echo 'Bars launched...'
