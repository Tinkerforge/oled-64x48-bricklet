#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_oled_64x48.h"

#define HOST "localhost"
#define PORT 4223
#define UID "ABC2" // Change to your UID

int main() {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	OLED64x48 oled;
	oled_64x48_create(&oled, UID, &ipcon);

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		exit(1);
	}
	// Don't use device before ipcon is connected

	// Clear display
	oled_64x48_clear_display(&oled);

	// Write "Hello World" starting from upper left corner of the screen
	oled_64x48_write_line(&oled, 0, 0, "Hello World");

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
}