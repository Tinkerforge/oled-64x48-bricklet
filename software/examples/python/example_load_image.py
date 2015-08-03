#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID
SCREEN_WIDTH = 64
SCREEN_HEIGHT = 48

from PIL import Image
from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_oled_64x48 import BrickletOLED64x48, OLED64x48

def draw_matrix(pixels):
    column = []

    for i in range(SCREEN_HEIGHT//8):
        column.append([])

        for j in range(SCREEN_WIDTH):
            page = 0
            for k in range(8):
                if pixels[i*8 + k][j] == True:
                    page |= 1 << k

            column[i].append(page)

    oled.new_window(0, SCREEN_WIDTH-1, 0, 5)

    for i in range(SCREEN_HEIGHT//8):
        oled.write(column[i])

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    oled = OLED64x48(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Load image to display
    image = Image.open("./tf_logo_64x48.png")
    width, height = image.size

    # Clear display
    oled.clear_display()
    
    # Boolean matrix with all pixels turned off
    pixel_matrix = [[False]*SCREEN_WIDTH for i in range(SCREEN_HEIGHT)]

    for h in range(height):
        for w in range(width):
            if image.getpixel((w, h)) > 0:
                pixel_matrix[h][w] = True

    draw_matrix(pixel_matrix)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
