function TCAS()
    f = figure('Name', 'TCAS 2D Simulation', 'Color', [0.2 0.2 0.25], ...
        'NumberTitle', 'off', 'Position', [200 200 900 600]);

    % UI Controls
    uicontrol(f, 'Style', 'text', 'String', 'Aircraft 1 Altitude (ft):', ...
        'Position', [50 550 150 20], 'BackgroundColor', f.Color, 'ForegroundColor', 'w');
    alt1Input = uicontrol(f, 'Style', 'edit', 'String', '30000', 'Position', [200 550 60 25]);

    uicontrol(f, 'Style', 'text', 'String', 'Aircraft 2 Altitude (ft):', ...
        'Position', [300 550 150 20], 'BackgroundColor', f.Color, 'ForegroundColor', 'w');
    alt2Input = uicontrol(f, 'Style', 'edit', 'String', '30000', 'Position', [450 550 60 25]);

    manualRA = 0;
    uicontrol(f, 'Style', 'pushbutton', 'String', 'Pull Up (A1)', ...
        'Position', [150 470 100 30], 'Callback', @(~,~) setManualRA(8));
    uicontrol(f, 'Style', 'pushbutton', 'String', 'Descend (A1)', ...
        'Position', [270 470 100 30], 'Callback', @(~,~) setManualRA(-8));

    uicontrol(f, 'Style', 'pushbutton', 'String', 'Run Simulation', ...
        'Position', [600 550 120 30], 'Callback', @runSimulation);
    uicontrol(f, 'Style', 'pushbutton', 'String', 'Reset', ...
        'Position', [740 550 80 30], 'Callback', @resetGUI);

    ax = axes('Parent', f, 'Position', [0.1 0.1 0.8 0.75]);
    axis(ax, [-100 100 28000 32000]);
    grid on; hold on;
    set(ax, 'Color', [0.75 0.9 1], 'XColor', 'w', 'YColor', 'w');
    title(ax, 'TCAS Altitude View (Horizontal Position vs Altitude)', 'Color', 'w');
    xlabel(ax, 'Horizontal Position (nm)', 'Color', 'w');
    ylabel(ax, 'Altitude (ft)', 'Color', 'w');

    a1 = []; a2 = [];

    function setManualRA(value)
        manualRA = value;
    end

    function resetGUI(~, ~)
        cla(ax);
        manualRA = 0;
        alt1Input.String = '30000';
        alt2Input.String = '30000';
    end

    function runSimulation(~, ~)
        lastRA1 = "";  % Previous advisory for Aircraft 1
        lastRA2 = "";  % Previous advisory for Aircraft 2

        cla(ax);
        trail1 = []; trail2 = [];
        manualRA = 0;
        currentRA1 = ""; currentRA2 = "";

        alt1 = str2double(alt1Input.String);
        alt2 = str2double(alt2Input.String);
        a1 = aircraft(1, -80, alt1, alt1, 0.5, 0, 0);
        a2 = aircraft(2,  80, alt2, alt2, -0.5, 0, 0);

        gf_width = 60;
        gf_height = 2000;
        RA_horizontal_trigger = gf_width / 2;
        RA_vertical_trigger = gf_height / 2;
        time_steps = 300;

        for step = 1:time_steps
            a1 = simulateStep(a1);
            a2 = simulateStep(a2);
            trail1 = [trail1; a1.x, a1.altitude];
            trail2 = [trail2; a2.x, a2.altitude];

            cla(ax);
            plot(ax, trail1(:,1), trail1(:,2), '--r', 'LineWidth', 1.5);
            plot(ax, trail2(:,1), trail2(:,2), '--b', 'LineWidth', 1.5);
            plot(ax, a1.x, a1.altitude, 'ro', 'MarkerSize', 14, 'MarkerFaceColor', 'r');
            plot(ax, a2.x, a2.altitude, 'bo', 'MarkerSize', 14, 'MarkerFaceColor', 'b');

            text(a1.x+2, a1.altitude+100, sprintf('ID:1 | %.0f ft', a1.altitude), ...
                 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(a2.x+2, a2.altitude+100, sprintf('ID:2 | %.0f ft', a2.altitude), ...
                 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');

            rectangle('Position', [a1.x - gf_width/2, a1.altitude - gf_height/2, ...
                                   gf_width, gf_height], ...
                      'Curvature', [1, 1], 'EdgeColor', 'r', 'LineWidth', 1.5, 'LineStyle', '--');

            horizontal_dist = abs(a1.x - a2.x);
            vertical_dist = abs(a1.altitude - a2.altitude);

            if manualRA ~= 0
                a1.vz = manualRA;
            elseif horizontal_dist <= RA_horizontal_trigger && vertical_dist <= RA_vertical_trigger
                delta_alt = a2.altitude - a1.altitude;

                if abs(delta_alt) > 500
                    currentRA1 = "Maintain";
                    currentRA2 = "Maintain";
                    a1.vz = 0;
                    a2.vz = 0;
                else
                    if delta_alt > 0  % A1 is below A2
                        currentRA1 = "Descend";
                        currentRA2 = "Climb";
                        a1.vz = -8;
                        a2.vz = 8;
                    elseif delta_alt < 0  % A1 is above A2
                        currentRA1 = "Climb";
                        currentRA2 = "Descend";
                        a1.vz = 8;
                        a2.vz = -8;
                    else  % Equal altitudes
                        currentRA1 = "Climb";
                        currentRA2 = "Descend";
                        a1.vz = 8;
                        a2.vz = -8;
                    end
                    % Play sound for Aircraft 1
if ~strcmp(currentRA1, lastRA1)
    playAlert(currentRA1);
    lastRA1 = currentRA1;
end
                end
            else
                % Outside RA zone — return to level flight
                currentRA1 = "Maintain";
                currentRA2 = "Maintain";
                a1.vz = 0;
                a2.vz = 0;
            end

            % Blinking advisory if needed
            if any(strcmp(currentRA1, ["Climb", "Descend"]))
    if mod(step, 2) == 0
        blinkColor = 'w';
    else
        blinkColor = 'y';
    end
    text(a1.x, a1.altitude + 300, ['⚠️ ' currentRA1 ' NOW!'], ...
         'Color', blinkColor, 'FontSize', 14, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center');
end

if any(strcmp(currentRA2, ["Climb", "Descend"]))
    if mod(step, 2) == 0
        blinkColor = 'w';
    else
        blinkColor = 'y';
    end
    text(a2.x, a2.altitude + 300, ['⚠️ ' currentRA2 ' NOW!'], ...
         'Color', blinkColor, 'FontSize', 14, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center');
end


            if abs(a1.x - a2.x) < 1 && abs(a1.altitude - a2.altitude) < 200
                text(0, 31000, '💥 COLLISION OCCURRED 💥', ...
                    'Color', 'r', 'FontSize', 16, 'FontWeight', 'bold', ...
                    'HorizontalAlignment', 'center', 'BackgroundColor', 'w');
                plot(ax, (a1.x + a2.x)/2, (a1.altitude + a2.altitude)/2, ...
                     'kp', 'MarkerSize', 20, 'MarkerFaceColor', 'r');
                return;
            end

            drawnow;
            pause(0.2);
        end
    end
end

function playAlert(advisory)
    switch advisory
        case "Climb"
            fprintf("\n🔊 Advisory: Climb\n");
            [y, Fs] = audioread('climb.wav'); sound(y, Fs);
        case "Descend"
            fprintf("\n🔊 Advisory: Descend\n");
            [y, Fs] = audioread('descend.wav'); sound(y, Fs);
        case "Maintain"
            fprintf("\nℹ️ Maintain current altitude\n");
            [y, Fs] = audioread('maintain.wav'); sound(y, Fs);
    end
end
