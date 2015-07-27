program ExamplePixelMatrix;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, Math, IPConnection, BrickletOLED64x48;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC2'; { Change to your UID }
  SCREEN_WIDTH = 64;
  SCREEN_HEIGHT = 48;

type
  TPixelMatrix = array[0..(SCREEN_HEIGHT - 1), 0..(SCREEN_WIDTH - 1)] of boolean;
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
  column: array[0..5, 0..(SCREEN_WIDTH - 1)] of byte;
begin
  for i := 0 to 5 do
  begin
    for j := 0 to SCREEN_WIDTH - 1 do
    begin
      page := 0;
      for k := 0 to 7 do begin
        if (pixels[(i*8) + k, j]) then begin
          page := page or (1 << k);
        end;
      end;

      column[i][j] := page;
    end;
  end;
  oled.NewWindow(0, SCREEN_WIDTH - 1, 0, 5);
  for i := 0 to 5 do begin
    oled.write(column[i]);
  end;
end;

procedure TExample.Execute;
var
  pixel_matrix: TPixelMatrix;
  w, h, p: integer;
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
  for h := 0 to SCREEN_HEIGHT - 1 do begin
    for w := 0 to SCREEN_WIDTH - 1 do begin
      pixel_matrix[h, w] := false;
    end;
  end;

  { Draw check pattern }
  for w := 0 to SCREEN_WIDTH - 1 do begin
    for h := 0 to SCREEN_HEIGHT - 1 do begin
      if (Floor(w/5) mod 2 = 0) then begin
        pixel_matrix[h, w] := true;
      end;
      if (Floor(h/5) mod 2 = 0) then begin
        pixel_matrix[h, w] := true;
      end;
    end;
  end;

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