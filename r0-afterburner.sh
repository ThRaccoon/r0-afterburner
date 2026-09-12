#!/bin/bash

# //
# // CPU
# //

cpu_idle=$(top -bn1 | grep '%Cpu' | awk -F ',' '{print $4}')
cpu_idle="${cpu_idle%%id*}"

cpu_usage=$(echo "100 - $cpu_idle" | bc)
cpu_usage=$(printf "%.0f" "$cpu_usage")

cpu_temp=$(sensors | grep 'Package id 0' | awk '{print $4}')
cpu_temp="${cpu_temp:1}"
cpu_temp="${cpu_temp%.*}"

cpu_fan_spd=$(sensors | grep 'fan2' | awk '{print $2}')

printf "CPU: %3s%%  |  Temp: %3sC  |  Fan: %4srpm\n" "$cpu_usage" "$cpu_temp" "$cpu_fan_spd"

# //
# // GPU
# //

gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
gpu_fan_spd=$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits)

printf "GPU: %3s%%  |  Temp: %3sC  |  Fan: %3s%%\n" "$gpu_usage" "$gpu_temp" "$gpu_fan_spd"

# //
# // RAM
# //

mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
mem_avail=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
mem_total_mb=$((mem_total / 1024))
mem_used_mb=$(((mem_total - mem_avail) / 1024))

printf "RAM:  %5s / %5sMB\n" "$mem_used_mb" "$mem_total_mb"
