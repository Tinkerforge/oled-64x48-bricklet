Imports System
Imports System.Math
Imports Tinkerforge

Module ExamplePixelMatrix
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your OLED 64x48 Bricklet
    Const WIDTH As Integer = 64
    Const HEIGHT As Integer = 48

    Sub DrawMatrix(ByRef oled As BrickletOLED64x48, ByVal pixels()() As Boolean)
        Dim pages()() As Byte = New Byte(HEIGHT \ 8)() {}

        For row As Integer = 0 To HEIGHT \ 8 - 1
            pages(row) = New Byte(WIDTH) {}

            For column As Integer = 0 To WIDTH - 1
                pages(row)(column) = 0

                For bit As Integer = 0 To 7
                    If pixels((row * 8) + bit)(column) Then
                        pages(row)(column) = pages(row)(column) Or Convert.ToByte(1 << bit)
                    End If
                Next bit
            Next column
        Next row

        oled.NewWindow(0, WIDTH - 1, 0, HEIGHT \ 8 - 1)

        For row As Integer = 0 To HEIGHT \ 8 - 1
            oled.Write(pages(row))
        Next
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim oled As New BrickletOLED64x48(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Clear display
        oled.ClearDisplay()

        ' Draw checkerboard pattern
        Dim pixels()() As Boolean = New Boolean(HEIGHT)() {}

        For row As Integer = 0 To HEIGHT - 1
            pixels(row) = New Boolean(WIDTH) {}

            For column As Integer = 0 To WIDTH - 1
                pixels(row)(column) = (row \ 8) Mod 2 = (column \ 8) Mod 2
            Next row
        Next column

        DrawMatrix(oled, pixels)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
