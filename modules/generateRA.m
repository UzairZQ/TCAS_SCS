
function advisory = generateRA(aircraft1, aircraft2, vertical_thresh, horizontal_thresh)
% generateRA - Determines resolution advisory based on aircraft positions
%
% Inputs:
%   aircraft1, aircraft2: structs with fields x, y, altitude
%   vertical_thresh: vertical separation threshold (e.g., 1000 feet)
%   horizontal_thresh: horizontal separation threshold (e.g., 5 nm)
%
% Output:
%   advisory: string ("Climb", "Descend", or "No Advisory")

    % Calculate horizontal distance
    dx = aircraft2.x - aircraft1.x;
    dy = aircraft2.y - aircraft1.y;
    horizontal_distance = sqrt(dx^2 + dy^2);

    % Calculate vertical separation
    vertical_separation = abs(aircraft1.altitude - aircraft2.altitude);

    % Check for conflict
    if vertical_separation < vertical_thresh && horizontal_distance < horizontal_thresh
        % Issue advisory for aircraft1
        if aircraft1.altitude <= aircraft2.altitude
            advisory = "Climb";
        else
            advisory = "Descend";
        end
    else
        advisory = "No Advisory";
    end
end
