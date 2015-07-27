import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletOLED64x48;

public class ExamplePixelMatrix {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID
	private static final short SCREEN_WIDTH = 64;
	private static final short SCREEN_HEIGHT = 48;

	static void drawMatrix(BrickletOLED64x48 oled, boolean[][] pixels) throws Exception {
		short[][] column = new short[6][SCREEN_WIDTH];

		for (short i = 0; i < (short)6; i++)
		{
			for (short j = 0; j < SCREEN_WIDTH; j++)
			{
				short page = 0;

				for (short k = 0; k < (short)8; k++)
				{
					if (pixels[(i*8)+k][j] == true)
					{
						page |= (short)(1 << k);
					}
				}
				column[i][j] = page;
			}
		}

		oled.newWindow((short)0, (short)(SCREEN_WIDTH-1), (short)0, (short)5);

		for (short i = 0; i < (short)6; i++)
		{
			oled.write(column[i]);
		}
	}

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletOLED64x48 oled = new BrickletOLED64x48(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Clear display
		oled.clearDisplay();

		boolean[][] pixelMatrix = new boolean[SCREEN_HEIGHT][SCREEN_WIDTH];

		// Pixel matrix with all pixels turned off
		for (short i = 0; i < SCREEN_HEIGHT; i++) {
			for (short j = 0; j < SCREEN_WIDTH; j++) {
				pixelMatrix[i][j] = false;
			}
		}

		// Draw check pattern
		for (short w = 0; w < SCREEN_WIDTH; w++) {
			for (short h = 0; h < SCREEN_HEIGHT; h++) {
				if (w/5 % 2 == 0) {
					pixelMatrix[h][w] = true;
				}
				if (h/5 % 2 == 0) {
					pixelMatrix[h][w] = true;
				}
			}
		}

		drawMatrix(oled, pixelMatrix);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
