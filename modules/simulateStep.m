function ac = simulateStep(ac)
% simulateStep - Updates aircraft position based on velocity
%
% Inputs:
%   ac: aircraft struct with vx, vy, vz
% Output:
%   ac: updated aircraft with new position

    ac.x = ac.x + ac.vx;
    ac.y = ac.y + ac.vy;
    ac.altitude = ac.altitude + ac.vz;
end
