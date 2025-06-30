addpath('modules');
addpath('plots');
addpath('tests');



% TCAS Simulation - Basic Prototype
% Simulates two aircraft and checks for conflict

% TCAS Simulation - Full Loop Version

% Parameters
vertical_sep_min = 1000;  % feet
horizontal_sep_min = 5;   % nautical miles
time_steps = 10;

% Create aircraft using constructor
aircraft1 = aircraft(1, -5, -5, 30000, 1, 1, 0);   % Moving NE
aircraft2 = aircraft(2, 5, 5, 29000, -1, -1, 100); % Moving SW and climbing

% Simulation loop
for step = 1:time_steps
    fprintf("\n=== Step %d ===\n", step);

    % Detect conflict
    conflict = detectConflict(aircraft1, aircraft2, vertical_sep_min, horizontal_sep_min);

    if conflict
        advisory = generateRA(aircraft1, aircraft2, vertical_sep_min, horizontal_sep_min);
    else
        advisory = "No Conflict";
    end

    % Display advisory
    fprintf("Aircraft 1 Position: (%.1f, %.1f, %.0fft)\n", aircraft1.x, aircraft1.y, aircraft1.altitude);
    fprintf("Aircraft 2 Position: (%.1f, %.1f, %.0fft)\n", aircraft2.x, aircraft2.y, aircraft2.altitude);
    fprintf("Advisory: %s\n", advisory);

    % Plot
    plotAircraft([aircraft1, aircraft2], step);

    % Update positions
    aircraft1 = simulateStep(aircraft1);
    aircraft2 = simulateStep(aircraft2);

    pause(1); % Optional: pause for 1 second between steps
end
