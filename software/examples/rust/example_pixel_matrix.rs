use std::{error::Error, io};

use tinkerforge::{ipconnection::IpConnection, oled_64x48_bricklet::*};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your OLED 64x48 Bricklet
const WIDTH: usize = 64;
const HEIGHT: usize = 48;

fn draw_matrix(oled: &OLED64x48Bricklet, pixels: [[bool; WIDTH]; HEIGHT]) {
    let mut pages = [[0u8; WIDTH]; HEIGHT / 8];
    for (col_idx, col) in pages.iter_mut().enumerate() {
        for (row_idx, byte) in col.iter_mut().enumerate() {
            for bit in 0..8 {
                if pixels[col_idx * 8 + bit][row_idx] {
                    *byte |= 1 << bit;
                }
            }
        }
    }

    oled.new_window(0, (WIDTH - 1) as u8, 0, (HEIGHT / 8 - 1) as u8);

    for row in 0..HEIGHT / 8 {
        oled.write(pages[row]);
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let oled_64x48_bricklet = OLED64x48Bricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Clear display
    oled_64x48_bricklet.clear_display();

    // Draw checkerboard pattern
    let mut pixels = [[false; WIDTH]; HEIGHT];
    for (row_idx, row) in pixels.iter_mut().enumerate() {
        for (col_idx, pixel) in row.iter_mut().enumerate() {
            *pixel = (row_idx / 8) % 2 == (col_idx / 8) % 2;
        }
    }

    draw_matrix(&oled_64x48_bricklet, pixels);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
