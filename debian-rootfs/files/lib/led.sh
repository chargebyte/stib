#!/bin/bash

led_set_attr() {
	local led="$1"
	local attr="$2"
	local val="$3"

	[ -f "/sys/class/leds/$led/$attr" ] && echo "$val" > "/sys/class/leds/$led/$attr"
}

led_get_attr() {
	local led="$1"
	local attr="$2"

	[ -f "/sys/class/leds/$led/$attr" ] && cat "/sys/class/leds/$led/$attr"
}

led_on() {
	local led="$1"
	local max_brightness="$(led_get_attr "$led" "max_brightness")"

	led_set_attr "$led" "trigger" "none"
	led_set_attr "$led" "brightness" "$max_brightness"
}

led_off() {
	local led="$1"

	led_set_attr "$led" "trigger" "none"
	led_set_attr "$led" "brightness" 0
}

led_timer() {
	local led="$1"
	local on="$2"
	local off="$3"

	led_set_attr "$led" "trigger" "timer"
	led_set_attr "$led" "delay_on" "$on"
	led_set_attr "$led" "delay_off" "$off"
}

led_transient() {
	local led="$1"

	led_set_attr "$led" "trigger" "transient"
	led_set_attr "$led" "duration" "10"
	led_set_attr "$led" "state" "1"
}

led_transient_kick() {
	local led="$1"

	led_set_attr "$led" "activate" 1
}
