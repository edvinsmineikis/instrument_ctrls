% Find a tcpip object.
obj1 = instrfind('Type', 'tcpip', 'RemoteHost', '169.254.105.235', 'RemotePort', 9221, 'Tag', '');

% Create the tcpip object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = tcpip('169.254.105.235', 9221);
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);


% Communicating with instrument object, obj1.
fprintf(obj1, 'op1 1');

% Disconnect from instrument object, obj1.
fclose(obj1);

% Configure instrument object, obj1.
set(obj1, 'Name', 'TCPIP-169.254.105.235');
set(obj1, 'RemoteHost', '169.254.105.235');

% Connect to instrument object, obj1.
fopen(obj1);

%% Working part of program:

% Communicating with instrument object, obj1.
fprintf(obj1, 'op1 0');     %Output is OFF
fprintf(obj1, 'i1 15');      %Set I=1A
fprintf(obj1, 'op1 1');     %Output is ON



v_max = 2.1
step_count = 100
v_step = v_max/step_count

spriegums = zeros(1, step_count);
strava = zeros(1, step_count);

for iter = 0:step_count
    v_val = string(iter*v_step);
    
    fprintf(obj1, 'v1 '+v_val);     %Set U=10V
    
    pause(0.8)
    
    data1 = query(obj1, 'v1o?');    %Measure voltage
    data2 = query(obj1, 'i1o?');    %Measure current
    data1(regexp(data1,'[A,V,\n]'))=[];
    data2(regexp(data2,'[A,V,\n]'))=[];
    spriegums(iter+1) = str2double(data1);  %Get voltage value
    strava(iter+1) = str2double(data2);     %Get current value
    
end

fprintf(obj1, 'op1 0');     %Output is OFF

%% Plot

figure(1)
plot(spriegums, strava)
hold on

R_meas= (spriegums(step_count)-spriegums(step_count-20))/(strava(step_count)-strava(step_count-20))

Vf_meas = spriegums(step_count) - R_meas*strava(step_count)

curve2  = zeros(2, 3);
curve2(1, 2) = Vf_meas;
curve2 (1,3) = Vf_meas + strava(step_count)*R_meas;
curve2 (2,3) = strava(step_count);
plot(curve2(1,:), curve2(2,:))
hold off





Vf = 1.12;
R = 0.0166;
