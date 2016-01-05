using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID
	private static int SCREEN_WIDTH = 64;
	private static int SCREEN_HEIGHT = 48;

	private static void DrawMatrix(BrickletOLED64x48 oled, bool[][] pixels)
	{
		byte[][] column = new byte[6][];

		for (int i = 0; i < 6; i++)
		{
			column[i] = new byte[SCREEN_WIDTH];
		}

		for (int i = 0; i < 6; i++)
		{
			for (int j = 0; j < SCREEN_WIDTH; j++)
			{
				byte page = 0;

				for (int k = 0; k < 8; k++)
				{
					if (pixels[(i*8)+k][j] == true)
					{
						page |= (byte)(1 << k);
					}
				}
				column[i][j] = page;
			}
		}
		oled.NewWindow(0, (byte)(SCREEN_WIDTH-1), 0, 5);

		for (int i = 0; i < 6; i++)
		{
			oled.Write(column[i]);
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
		bool[][] pixelMatrix = new bool[SCREEN_HEIGHT][];

		for (int h = 0; h < SCREEN_HEIGHT; h++)
		{
			pixelMatrix[h] = new bool[SCREEN_WIDTH];

			for (int w = 0; w < SCREEN_WIDTH; w++)
			{
				pixelMatrix[h][w] = (h / 8) % 2 == (w / 8) % 2;
			}
		}

		DrawMatrix(oled, pixelMatrix);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
