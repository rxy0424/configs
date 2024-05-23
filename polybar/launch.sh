#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
#echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
#polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
# echo "---" | tee -a /tmp/polybar1.log
# polybar example 2>&1 | tee -a /tmp/polybar1.log & disown

#if type "xrandr" > /dev/null; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        if [ $m == 'DP-2' ]
#        then
#            POLYBAR_MONITOR=$m POLYBAR_DPI=96 polybar primary &
#        elif [ $m == 'HDMI-1' ]
#        then
#            POLYBAR_MONITOR=$m POLYBAR_DPI=96 polybar side &
#        else
#            POLYBAR_MONITOR=$m polybar primary&
#        fi
#    done #else
#    POLYBAR_MONITOR="" polybar primary &
#fi

if [ ! -f "${HOME}/.config/polybar/monitor.txt" ]; then
  echo "default"
  polybar primary &
else
  while IFS=' ' read -r name dpi barname; do
    POLYBAR_MONITOR="$name" POLYBAR_DPI="$dpi" polybar "$barname" &
    echo "$name" "$dpi" "$barname"
  done < "${HOME}/.config/polybar/monitor.txt"
fi

echo "Bars launched..."
