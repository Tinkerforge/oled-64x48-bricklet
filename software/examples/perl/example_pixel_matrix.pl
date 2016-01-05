#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletOLED64x48;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change to your UID
use constant SCREEN_WIDTH => 64;
use constant SCREEN_HEIGHT => 48;

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $oled = Tinkerforge::BrickletOLED64x48->new(&UID, $ipcon); # Create device object

sub draw_matrix {
    my $oled = shift;
    my $ref_pixel_matrix = shift;
    my @pixels = @{$ref_pixel_matrix};
    my @column = ();
    my $page = 0;

    foreach my $i (0..SCREEN_HEIGHT/8-1) {
        $column[$i] = ();
        foreach my $j (0..SCREEN_WIDTH-1) {
            $page = 0;

            foreach my $k (0..7) {
                if ($pixels[($i*8) + $k][$j]) {
                    $page |= 1 << $k;
                }
            }
            $column[$i][$j] = $page;
        }
    }
    $oled->new_window(0, &SCREEN_WIDTH-1, 0, 5);

    foreach my $i (0..SCREEN_HEIGHT/8-1) {
        $oled->write($column[$i]);
    }
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Clear display
$oled->clear_display();

# Draw checkerboard pattern
my @pixel_matrix=();
foreach my $h (0..&SCREEN_HEIGHT-1) {
    $pixel_matrix[$h] = ();
    foreach my $w (0..&SCREEN_WIDTH-1) {
        $pixel_matrix[$h][$w] = (($h / 8) % 2) == (($w / 8) % 2);
    }
}

draw_matrix($oled, \@pixel_matrix);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
