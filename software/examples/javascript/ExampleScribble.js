var Tinkerforge = require('tinkerforge');
var GM = require('gm'); // FIXME: maybe use node-gd instead
var getPixels = require('get-pixels');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change XYZ to the UID of your OLED 64x48 Bricklet
var WIDTH = 64;
var HEIGHT = 48;

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var oled = new Tinkerforge.BrickletOLED64x48(UID, ipcon); // Create device object
var originX = WIDTH / 2;
var originY = HEIGHT / 2;
var length = HEIGHT / 2 - 2;
var angle = 0;

function drawImage(oled, image) {
    // FIXME: GraphicsMagick doesn't seem to have a way to access the individual
    // pixels. Convert to PNG and then used get-pixels to read the pixels back.
    // This is far from ideal, but better than nothing.
    image.toBuffer('PNG', function (err, buffer) {
        if (err) {
            console.log('toBuffer: ' + err);
            return;
        }

        getPixels(buffer, 'image/png', function(err, pixels) {
            if (err) {
                console.log('getPixels: ' + err);
                return;
            }

            column = [];

            for (var i = 0; i < HEIGHT/8; i++) {
                column[i] = [];
            }

            for (var i = 0; i < HEIGHT/8; i++) {
                for (var j = 0; j < WIDTH; j++) {
                    page = 0;

                    for (var k = 0; k < 8; k++) {
                        if (pixels.get(j, i*8 + k, 0) > 0) {
                            page |= 1 << k;
                        }
                    }

                    column[i][j] = page;
                }
            }

            oled.newWindow(0, WIDTH-1, 0, 5)

            for (var i = 0; i < HEIGHT/8; i++) {
                oled.write(column[i])
            }
        });
    });
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

        // Draw rotating line
        function render() {
            // FIXME: Creating the image once and reusing it would be better, but
            // on the second call toBuffer() fails with "Stream yields empty buffer"
            var image = GM(WIDTH, HEIGHT, '#000');
            var radians = angle * Math.PI / 180;
            var x = Math.floor(originX + length * Math.cos(radians));
            var y = Math.floor(originY + length * Math.sin(radians));

            image.fill('#FFF').drawLine(originX, originY, x, y);

            drawImage(oled, image);

            angle++;
        }

        setInterval(render, 25);
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
