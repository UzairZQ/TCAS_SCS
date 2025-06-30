function conflict = detectConflict(aircraft1, aircraft2, vertical_thresh, horizontal_thresh)
% detectConflict - Checks if two aircraft are in potential conflict
%
% Inputs:
%   aircraft1, aircraft2: structs with fields x, y, altitude
%   vertical_thresh: vertical separation threshold (in feet)
%   horizontal_thresh: horizontal separation threshold (in nm)
%
% Output:
%   conflict: true if both vertical and horizontal separation are below thresholds

   [vertical_separation, horizontal_distance] = separationCheck(aircraft1, aircraft2);

    % Check conflict conditions
    conflict = (vertical_separation < vertical_thresh) && (horizontal_distance < horizontal_thresh);
end

