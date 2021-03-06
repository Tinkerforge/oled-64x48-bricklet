Imports System
Imports Tinkerforge

Module ExampleHelloWorld
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your OLED 64x48 Bricklet

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim oled As New BrickletOLED64x48(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Clear display
        oled.ClearDisplay()

        ' Write "Hello World" starting from upper left corner of the screen
        oled.WriteLine(0, 0, "Hello World")

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
