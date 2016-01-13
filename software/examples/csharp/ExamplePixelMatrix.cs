using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID
	private static int WIDTH = 64;
	private static int HEIGHT = 48;

	private static void DrawMatrix(BrickletOLED64x48 oled, bool[][] pixels)
	{
		byte[][] pages = new byte[HEIGHT / 8][];

		for (int row = 0; row < HEIGHT / 8; row++)
		{
			pages[row] = new byte[WIDTH];

			for (int column = 0; column < WIDTH; column++)
			{
				pages[row][column] = 0;

				for (int bit = 0; bit < 8; bit++)
				{
					if (pixels[(row * 8) + bit][column])
					{
						pages[row][column] |= (byte)(1 << bit);
					}
				}
			}
		}

		oled.NewWindow(0, (byte)(WIDTH - 1), 0, (byte)(HEIGHT / 8 - 1));

		for (int row = 0; row < HEIGHT / 8; row++)
		{
			oled.Write(pages[row]);
		}
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletOLED64x48 oled = new BrickletOLED64x48(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Clear display
		oled.ClearDisplay();

		// Draw checkerboard pattern
		bool[][] pixels = new bool[HEIGHT][];

		for (int row = 0; row < HEIGHT; row++)
		{
			pixels[row] = new bool[WIDTH];

			for (int column = 0; column < WIDTH; column++)
			{
				pixels[row][column] = (row / 8) % 2 == (column / 8) % 2;
			}
		}

		DrawMatrix(oled, pixels);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
