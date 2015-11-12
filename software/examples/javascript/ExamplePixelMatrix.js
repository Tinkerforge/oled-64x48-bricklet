var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change to your UID
var SCREEN_WIDTH = 64;
var SCREEN_HEIGHT = 48;

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var oled = new Tinkerforge.BrickletOLED64x48(UID, ipcon); // Create device object

function drawMatrix(oled, pixels) {
	column = [];

	for (var i = 0; i < SCREEN_HEIGHT/8; i++) {
		column[i] = [];
	}

	for (var i = 0; i < SCREEN_HEIGHT/8; i++) {
		for (var j = 0; j < SCREEN_WIDTH; j++) {
			page = 0;

			for (var k = 0; k < 8; k++) {
				if (pixels[i*8 + k][j] == true) {
					page |= 1 << k;
				}
			}
			column[i][j] = page;
		}
	}

	oled.newWindow(0, SCREEN_WIDTH-1, 0, 5)

	for (var i = 0; i < SCREEN_HEIGHT/8; i++) {
		oled.write(column[i])
	}
}

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Clear display
        oled.clearDisplay();

		// Pixel matrix with all pixels turned off
		var pixelMatrix = [];

		for(var i = 0; i < SCREEN_HEIGHT; i++) {
			pixelMatrix[i] = [];
			for(var j = 0; j < SCREEN_WIDTH; j++) {
				pixelMatrix[i][j] = false;
			}
		}

		// Draw check pattern
		for (var w = 0; w < SCREEN_WIDTH; w++) {
			for (var h = 0; h < SCREEN_HEIGHT; h++) {
				if (Math.floor(w/5) % 2 == 0) {
					pixelMatrix[h][w] = true;
				}
				if (Math.floor(h/5) % 2 == 0) {
					pixelMatrix[h][w] = true;
				}
			}
		}
		drawMatrix(oled, pixelMatrix);
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
