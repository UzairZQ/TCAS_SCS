function plotAircraft(aircraftArray, step)
% plotAircraft - Visualizes aircraft positions in 3D space with trails
% Inputs:
%   aircraftArray : Array of aircraft structs
%   step          : Current simulation step (for title update)

    persistent trails;

    % Initialize trail storage
    if isempty(trails)
        trails = containers.Map('KeyType','int32','ValueType','any');
    end

    % Clear figure and set fancy settings
    figure(1); clf;
    set(gcf, 'Color', [0.15 0.17 0.2]);  % dark figure background
    axes1 = gca;
    set(axes1, 'Color', [0.1 0.1 0.15]);  % dark plot background
    grid on; box on; hold on;

    % Plot each aircraft and update trail
    for i = 1:length(aircraftArray)
        ac = aircraftArray(i);

        % Store historical positions
        if ~isKey(trails, ac.id)
            trails(ac.id) = [ac.x; ac.y; ac.altitude];
        else
            trails(ac.id) = [trails(ac.id), [ac.x; ac.y; ac.altitude]];
        end

        % Plot trail line
        trail = trails(ac.id);
        plot3(trail(1,:), trail(2,:), trail(3,:), '--', ...
              'Color', getColor(ac.id), 'LineWidth', 1.5);

        % Plot aircraft as a filled marker
        plot3(ac.x, ac.y, ac.altitude, 'o', ...
              'MarkerSize', 14, ...
              'LineWidth', 2, ...
              'MarkerEdgeColor', 'k', ...
              'MarkerFaceColor', getColor(ac.id), ...
              'DisplayName', ['Aircraft ' num2str(ac.id)]);

        % Add ID label above each aircraft
        text(ac.x, ac.y, ac.altitude + 200, ...
            ['ID: ' num2str(ac.id)], 'FontSize', 10, ...
            'Color', 'w', 'FontWeight', 'bold');
    end

    % Axes and labels
    xlabel('X Position (nm)', 'FontWeight', 'bold', 'Color', 'w');
    ylabel('Y Position (nm)', 'FontWeight', 'bold', 'Color', 'w');
    zlabel('Altitude (ft)', 'FontWeight', 'bold', 'Color', 'w');
    title(['TCAS Simulation - Step ' num2str(step)], ...
          'FontSize', 14, 'FontWeight', 'bold', 'Color', 'w');

    % Axes styling
    set(gca, 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    view(135, 30);  % Angled 3D view
    legend('show', 'TextColor', 'w', 'Location', 'northeastoutside');

    % Axis limits (optional - adjust based on scenario)
    xlim([-100 100]);
    ylim([-100 100]);
    zlim([28000 32000]);

end

% Helper function to assign colors based on aircraft ID
function color = getColor(id)
    colors = {'r', 'c', 'g', 'm', 'y', 'w'};  % high contrast on dark bg
    color = colors{mod(id - 1, length(colors)) + 1};
end
