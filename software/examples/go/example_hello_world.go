package main

import (
	"fmt"
	"tinkerforge/ipconnection"
	"tinkerforge/oled_64x48_bricklet"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your OLED 64x48 Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	oled, _ := oled_64x48_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	// Clear display
	oled.ClearDisplay()

	// Write "Hello World" starting from upper left corner of the screen
	oled.WriteLine(0, 0, "Hello World")

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
