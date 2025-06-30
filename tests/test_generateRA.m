% test_generateRA.m - Unit tests for generateRA()

% Test case 1: Aircraft1 below Aircraft2, within conflict range
a1 = aircraft(1, 0, 0, 29000, 0, 0, 0);
a2 = aircraft(2, 1, 1, 29500, 0, 0, 0);
ra = generateRA(a1, a2, 1000, 5);
assert(strcmp(ra, "Climb"), "Test 1 Failed: Expected 'Climb'");

% Test case 2: Aircraft1 above Aircraft2, within conflict range
a1.altitude = 30000;
a2.altitude = 29500;
ra = generateRA(a1, a2, 1000, 5);
assert(strcmp(ra, "Descend"), "Test 2 Failed: Expected 'Descend'");

% Test case 3: Aircraft too far horizontally → No conflict
a2.x = 100; a2.y = 100;
ra = generateRA(a1, a2, 1000, 5);
assert(strcmp(ra, "No Advisory"), "Test 3 Failed: Expected 'No Advisory'");

% Test case 4: Aircraft too far vertically → No conflict
a2.x = 1; a2.y = 1; a2.altitude = 28000;
ra = generateRA(a1, a2, 1000, 5);
assert(strcmp(ra, "No Advisory"), "Test 4 Failed: Expected 'No Advisory'");

disp("All tests passed for generateRA()");
