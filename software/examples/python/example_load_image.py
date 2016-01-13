#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID
WIDTH = 64
HEIGHT = 48

import sys
from PIL import Image
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_oled_64x48 import BrickletOLED64x48

def draw_matrix(oled, pixels):
    pages = []

    # Convert pixels into pages
    for row in range(HEIGHT // 8):
        pages.append([])

        for column in range(WIDTH):
            page = 0

            for bit in range(8):
                if pixels[(row * 8) + bit][column]:
                    page |= 1 << bit

            pages[row].append(page)

    # Write all pages
    oled.new_window(0, WIDTH - 1, 0, HEIGHT // 8 - 1)

    for row in range(HEIGHT // 8):
        oled.write(pages[row])

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    oled = BrickletOLED64x48(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Clear display
    oled.clear_display()

    # Convert image to black/white pixels
    image = Image.open(sys.argv[1])
    image_data = image.load()
    pixels = []

    for row in range(HEIGHT):
        pixels.append([])

        for column in range(WIDTH):
            if column < image.size[0] and row < image.size[1]:
                pixel = image_data[column, row] > 0
            else:
                pixel = False

            pixels[row].append(pixel)

    draw_matrix(oled, pixels)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
