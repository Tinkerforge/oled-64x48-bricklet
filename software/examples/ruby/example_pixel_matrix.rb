#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_oled_64x48'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change to your UID
SCREEN_WIDTH = 64
SCREEN_HEIGHT = 48

def draw_matrix(oled, pixels)
  column = []

  for i in 0..SCREEN_HEIGHT/8 - 1
    column[i] = []

    for j in 0..SCREEN_WIDTH-1
      page = 0

      for k in 0..7
        if pixels[i*8 + k][j] == true
          page |= 1 << k
        end
      end

      column[i][j] = page
    end
  end

  oled.new_window(0, SCREEN_WIDTH-1, 0, 5)

  for i in 0..SCREEN_HEIGHT/8 - 1
    oled.write(column[i])
  end
end

ipcon = IPConnection.new # Create IP connection
oled = BrickletOLED64x48.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Clear display
oled.clear_display

# Pixel matrix with all pixels turned off
pixel_matrix = []

for i in 0..SCREEN_HEIGHT-1
  pixel_matrix[i] = []

  for j in 0..SCREEN_WIDTH-1
    pixel_matrix[i][j] = false
  end
end

# Draw check pattern
for w in 0..SCREEN_WIDTH-1
  for h in 0..SCREEN_HEIGHT-1
    if w/5 % 2 == 0
      pixel_matrix[h][w] = true
    end
    if h/5 % 2 == 0
      pixel_matrix[h][w] = true
    end
  end
end

draw_matrix oled, pixel_matrix

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
