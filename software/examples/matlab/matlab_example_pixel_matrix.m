function matlab_example_pixel_matrix()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletOLED64x48;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID
    SCREEN_WIDTH = 64;
    SCREEN_HEIGHT = 48;

    function draw_matrix(oled, pixels)
        column = cell(1, 6);
        for i = 1:(SCREEN_HEIGHT/8) - 1
            column{i} = zeros(1,64);
            for j = 1:SCREEN_WIDTH
                page = 0;
                for k = 0:7
                    if pixels(i*8 + k, j) == true
                        page = bitor(page, bitshift(1, k));
                    end
                end
                column{i}(j) = page;
            end
        end
        oled.newWindow(0, SCREEN_WIDTH-1, 0, 5);
        for i = 1:(SCREEN_HEIGHT/8) - 1
            oled.write(column{i});
        end
    end

    ipcon = IPConnection(); % Create IP connection
    oled = BrickletOLED64x48(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Clear display
    oled.clearDisplay();

    % Boolean matrix with all pixels turned off
    pixel_matrix = false(SCREEN_HEIGHT, SCREEN_WIDTH);

    %Draw check pattern
    for w = 1:SCREEN_WIDTH
        for h = 1:SCREEN_HEIGHT
            if mod(floor(w/5), 2) == 0
                pixel_matrix(h, w) = true;
            end
            if mod(floor(h/5), 2) == 0
                pixel_matrix(h, w) = true;
            end
        end
    end

    draw_matrix(oled, pixel_matrix);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end
