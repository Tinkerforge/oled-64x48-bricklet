#!/bin/bash
# Connects to localhost:4223 by default, use --host and --port to change this

# This example requires Bash 4

uid=XYZ # Change XYZ to the UID of your OLED 64x48 Bricklet

screen_width=64
screen_height=48

function draw_matrix {
	declare -A column

	for ((i=0; i<${screen_height}/8; i++))
	do
		for ((j=0; j<${screen_width}; j++))
		do
			page=0

			for ((k=0; k<8; k++))
			do
				if ((${pixel_matrix[$((((${i}*8))+${k})),${j}]}))
				then
					page=$((${page}|$((1<<${k}))))
				fi
			done
			column[${i},${j}]=${page}
		done
	done
	tinkerforge call oled-64x48-bricklet ${uid} new-window 0 $((${screen_width}-1)) 0 5

	for ((i=0; i<${screen_height}/8; i++))
	do
		write_bytes=""
		for ((j=0; j<${screen_width}; j++))
		do
			write_bytes+=${column[${i},${j}]}
			if ((${j}==${screen_width}-1))
			then
				continue
			fi
			write_bytes+=","
		done
		tinkerforge call oled-64x48-bricklet ${uid} write ${write_bytes}
	done
}

# Clear display
tinkerforge call oled-64x48-bricklet $uid clear-display

# Draw checkerboard pattern
declare -A pixel_matrix

for ((h=0;h<${screen_height};h++))
do
	for ((w=0;w<${screen_width};w++))
	do
		pixel_matrix[${h},${w}]=$((((${h}/8))%2==((${w}/8))%2))
	done
done

draw_matrix
