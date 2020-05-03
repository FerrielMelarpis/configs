#!/usr/bin/env bash 
function min {
    echo $[$1 < $2 ? $1 : $2];
}

function max {
    echo $[$1 > $2 ? $1 : $2];
}

function get_brightness {
    cat /sys/class/leds/asus::kbd_backlight/brightness;
}

function set_brightness {
    echo $1 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness
}

function get_max_brightness {
    cat /sys/class/leds/asus::kbd_backlight/max_brightness
}

function kbd_backlight {
    local brightness=`get_brightness`

    if [ $1 = "up" ]; then
        local max_brightness=`get_max_brightness`
        brightness=`min $[$brightness + 1] $max_brightness`
    else
        brightness=`max $[$brightness - 1] 0`
    fi

    set_brightness $brightness
} 

kbd_backlight $1
