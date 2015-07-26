program ExamplePixelMatrix;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletOLED64x48;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC2'; { Change to your UID }
  SCREEN_WIDTH = 64;
  SCREEN_HEIGHT = 48;

type
  TPixelMatrix = array[0..SCREEN_HEIGHT - 1, 0..SCREEN_WIDTH - 1] of boolean;
  TExample = class
  private
    ipcon: TIPConnection;
    oled: TBrickletOLED64x48;
    procedure DrawMatrix(pixels: TPixelMatrix);
  public
    procedure Execute;
end;

var
  e: TExample;

procedure TExample.DrawMatrix(pixels: TPixelMatrix);
var
  i, j, k: integer;
  page: byte;
  column: array[0..5, 0..SCREEN_WIDTH - 1] of byte;

begin

  for i := 0 to 5 do
    for j := 0 to SCREEN_WIDTH - 1 do
      page := 0;

      for k := 0 to 7 do
        if (pixels[(i*8) + k, j] = true) then
          page := page or (1 << k);

      column[i][j] := page;

  oled.NewWindow(0, SCREEN_WIDTH - 1, 0, 5);

  for i := 0 to 5 do
    oled.write(column[i]);
end;

procedure TExample.Execute;
var
  pixel_matrix: TPixelMatrix;
  i, j: integer;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  oled := TBrickletOLED64x48.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Clear display }
  oled.ClearDisplay;

  { Pixel matrix with all pixels turned off }
  for i := 0 to SCREEN_HEIGHT - 1 do
    for j := 0 to SCREEN_WIDTH - 1 do
      pixel_matrix[i, j] := false;

  { Draw check pattern }
  for i := 0 to SCREEN_WIDTH - 1 do
    for j := 0 to SCREEN_HEIGHT - 1 do
      if (Int64(i/5) mod 2 = 0) then
        pixel_matrix[j, i] := true;
      if (Int64(j/5) mod 2 = 0) then
        pixel_matrix[j, i] := true;

  e.DrawMatrix(pixel_matrix);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
