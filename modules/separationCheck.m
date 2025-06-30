function [vertical_sep, horizontal_sep] = separationCheck(aircraft1, aircraft2)
% separationCheck - Calculates vertical and horizontal separation
%
% Inputs:
%   aircraft1, aircraft2 : Structs with position and altitude
%
% Outputs:
%   vertical_sep         : Absolute altitude difference (in feet)
%   horizontal_sep       : Euclidean distance in X-Y plane (in nm)

    dx = aircraft2.x - aircraft1.x;
    dy = aircraft2.y - aircraft1.y;
    horizontal_sep = sqrt(dx^2 + dy^2);

    vertical_sep = abs(aircraft1.altitude - aircraft2.altitude);
end
