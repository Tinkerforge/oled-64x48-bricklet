#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_oled_64x48.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID
#define SCREEN_WIDTH 64
#define SCREEN_HEIGHT 48

void draw_matrix(OLED64x48 *oled, bool (*pixels)[SCREEN_WIDTH]) {
	uint8_t column[SCREEN_HEIGHT/8][SCREEN_WIDTH];
	int i, j, k;
	uint8_t page = 0;

	for (i = 0; i < SCREEN_HEIGHT/8; i++) {
		for (j = 0; j < SCREEN_WIDTH; j++) {
			page = 0;

			for (k = 0; k < 8; k++) {
				if (pixels[(i*8) + k][j] == true) {
					page |= (1 << k);
				}
			}

			column[i][j] = page;
		}
	}

	oled_64x48_new_window(oled, 0, SCREEN_WIDTH-1, 0, 5);

	for (i = 0; i < SCREEN_HEIGHT/8; i++) {
		oled_64x48_write(oled, column[i]);
	}
}

int main(void) {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	OLED64x48 oled;
	oled_64x48_create(&oled, UID, &ipcon);

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		return 1;
	}
	// Don't use device before ipcon is connected

	// Clear display
	oled_64x48_clear_display(&oled);

	// Draw checkerboard pattern
	int h, w;
	bool pixel_matrix[SCREEN_HEIGHT][SCREEN_WIDTH];

	for (h = 0; h < SCREEN_HEIGHT; h++) {
		for (w = 0; w < SCREEN_WIDTH; w++) {
			pixel_matrix[h][w] = (h / 8) % 2 == (w / 8) % 2;
		}
	}

	draw_matrix(&oled, pixel_matrix);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
	return 0;
}
