#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletOLED64x48;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your OLED 64x48 Bricklet

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $oled = Tinkerforge::BrickletOLED64x48->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Clear display
$oled->clear_display();

# Write "Hello World" starting from upper left corner of the screen
$oled->write_line(0, 0, "Hello World");

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
