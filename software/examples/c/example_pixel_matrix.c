#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_oled_64x48.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID
#define SCREEN_WIDTH 64
#define SCREEN_HEIGHT 48

int draw_matrix(OLED64x48 *ptr_oled, bool (*pixels)[SCREEN_WIDTH]) {
    uint8_t column[6][64];
    
    int i = 0;
    int j = 0;
    int k = 0;
    uint8_t page = 0;

    for (i = 0; i < 6; i++) {
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
    oled_64x48_new_window(ptr_oled, 0, SCREEN_WIDTH-1, 0, 5);

    for (i = 0; i < 6; i++) {
        oled_64x48_write(ptr_oled, column[i]);
    }
}

int main() {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	OLED64x48 oled;
	oled_64x48_create(&oled, UID, &ipcon);

	int i = 0;
	int j = 0;
	int w = 0;
	int h = 0;
	bool pixel_matrix[SCREEN_HEIGHT][SCREEN_WIDTH];

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		exit(1);
	}
	// Don't use device before ipcon is connected

	// Clear display
	oled_64x48_clear_display(&oled);

	// Pixel matrix with all pixels turned off
	for (i = 0; i < SCREEN_HEIGHT; i++) {
	  for (j = 0; j < SCREEN_WIDTH; j++) {
	    pixel_matrix[i][j] = false;
	  }
	}

	// Draw check pattern
	for (w = 0; w < SCREEN_WIDTH; w++) {
	  for (h = 0; h < SCREEN_HEIGHT; h++) {
	    if ((w/5) % 2 == 0) {
	      pixel_matrix[h][w] = true;
	    }
	    if ((h/5) % 2 == 0) {
	      pixel_matrix[h][w] = true;
	    }
	  }
	}

	draw_matrix(&oled, pixel_matrix);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
}
