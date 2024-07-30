% Generate simulation results if they don't exist
if ~exist('Complete_model', 'var')
    sim('Complete_model')
end
time = simlog.Frost_valve.Frost_valve_coil.Q.series.time;
operating_temperature = simlog.Operating_theatre_1.H.T.series.values('degC');
% Given parameters
h = 30; % Convective heat transfer coefficient (W/m^2 K)
mass_air = 203; % Mass of air in the room (kg)
mass_people = 800;
cp_person = 3000;
cp = 1005; % Specific heat capacity of air (J/kg K)
A = 1; % Surface area of the vent (m^2)
T_room_initial = 8; % Initial room temperature (°C)
%air_temp_data = [time, operating_temperature]
% Load tabular data for incoming air temperature against time
% Assuming the data is stored in a variable named 'air_temp_data'
% The first column contains time (in seconds), and the second column contains temperature (in °C)
% Example:
% air_temp_data = [0 25; 1800 30; 3600 35; ...];

% Define time vector based on the tabular data

% Interpolate incoming air temperature data to get temperature at each time step
%T_air = interp1(air_temp_data(:, 1), air_temp_data(:, 2), time);

% Initialize room temperature vector
T_room = zeros(size(time));
T_room(1) = T_room_initial; % Set initial room temperature

% Calculate temperature dynamics of the room over time
for i = 2:length(time)
    % Calculate heat transfer rate from incoming air to the room
    Q_in = h * A * (operating_temperature(i) - T_room(i-1));
    
    % Calculate change in room temperature using energy balance equation
    dT = Q_in / (mass_air * cp);
    
    % Update room temperature
    T_room(i) = T_room(i-1) + dT;
end

% Plot room temperature against time
figure;
plot(time, T_room, 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Room Temperature (°C)');
title('Room Temperature vs. Time');
grid on;


