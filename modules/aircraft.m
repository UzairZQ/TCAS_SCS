function ac = aircraft(id, x, y, altitude, vx, vy, vz)
% aircraft - Creates an aircraft structure with position and velocity
%
% Inputs:
%   id       : Unique aircraft ID
%   x, y     : Initial position (nautical miles)
%   altitude : Initial altitude (feet)
%   vx, vy   : Velocity components in horizontal plane (nm per step)
%   vz       : Vertical speed (feet per step)
%
% Output:
%   ac       : Struct containing all aircraft state info

    ac = struct();
    ac.id = id;
    ac.x = x;
    ac.y = y;
    ac.altitude = altitude;
    ac.vx = vx;
    ac.vy = vy;
    ac.vz = vz;
end
