function temperature_evolution()

    % Constants (will be defined at the end)
    materials = {'Aluminum', 'Copper'};
    coatings = {'Gold', 'Silver', 'Black', 'White'};
    orientations = {'Perpendicular Orbit', 'Parallel Orbit'};

    % Stefan-Boltzman constant
    SB_constant = 5.67*10^(-8); % unit: W/ m^2* K^4

    % Satellite dimensions
    Volume = 0.001; % unit: m^3
    radius = ((3*Volume)/(4*pi))^(1/3); % unit: m
    A = 4*pi*radius^2; % unit: m^2

    % Time and Initial Conditions
    miu = 3.986*10^14; % unit: m^3/ s^2
    earth_radius = 6370*10^3; % unit: m
    altitude = 500*10^3; % unit: m
    orbit_duration_s = sqrt((earth_radius+altitude)^3*(4*pi^2)/miu); % unit: s
    dt = orbit_duration_s/100; % unit s
    Total_Duration = orbit_duration_s * 20; % unit s
    num_steps = Total_Duration / dt; 

    % Calculating the number of rows and columns for the subplot grid
    numRows = 8;
    numColumns = 4;

    % Initializing the plotIndex
    plotIndex = 0;

    % Initializing the figure
    figure;

    % Tightening the margins and reduce spacing
    leftMargin = 0.04;      % smaller margin
    rightMargin = 0.96;     % smaller margin
    topMargin = 0.97;       % smaller margin
    bottomMargin = 0.05;    % smaller margin
    verticalSpacing = 0.04; % reduced spacing
    horizontalSpacing = 0.04; % reduced spacing

    % Recalculating plotWidth and plotHeight based on new margins and spacing
    plotWidth = (rightMargin - leftMargin - (numColumns - 1) * horizontalSpacing) / numColumns;
    plotHeight = (topMargin - bottomMargin - (numRows - 1) * verticalSpacing) / numRows;

    % Main loop
    for i = 1:length(materials)
        for j = 1:length(coatings)
            for k = 1:length(orientations)

                % Fetch properties
                [cp, density, emissivity, absorptivity] = get_properties(materials{i}, coatings{j});

                % Radiation constants
                Earth_radiance = 250;  % unit: W/m^2
                Earth_emissivity = 0.95;

                % Temperature evolution array
                T = zeros(1, num_steps); % unit: °C
                T0 = 0;
                T(1) = T0;  % initial temperature

                % Loop for the temperature 
                for idx = 2:num_steps
                
                % Time passed
                t = idx * dt; % unit: s

                    % Checking if the satellite is in direct sunlight
                    if k==1
                        if mod(t, orbit_duration_s)<orbit_duration_s/2
                            Sun_irradiance = 0; % unit: W/m^2
                        else
                            Sun_irradiance = 1400; % unit: W/m^2
                        end
                    else
                        if mod(t, orbit_duration_s)<orbit_duration_s*0.1
                            Sun_irradiance = 0; % unit: W/m^2
                        else
                            Sun_irradiance = 1400; % unit: W/m^2
                        end
                    end
                    
                    % Computing the radiation received and emitted respectively 
                    radiation_received = Sun_irradiance * absorptivity * A/2 + ...
                            (Earth_radiance * A/2 * Earth_emissivity);
                    radiation_emitted = (T(idx-1)+273.15)^4 * SB_constant * ...
                        emissivity * A;

                    % Mass
                    m = density * Volume; % unit: kg

                    % Change in temperature
                    dT = (radiation_received - radiation_emitted) * dt / (m * cp);
                    T(idx) = T(idx-1) + dT;
                end

                % Creating a time vector for plotting
                times = 0:dt:(num_steps-1)*dt; 

                % Incrementing plotIndex for each new plot
                plotIndex = plotIndex + 1;

                % Determining the subplot index for the temperature plot
                tempPlotIndex = (plotIndex - 1) * 2 + 1;

                % Calculating the position for the current subplot
                [left, bottom] = ind2sub([numColumns, numRows], tempPlotIndex);
                left = leftMargin + (left - 1) * (plotWidth + horizontalSpacing);
                bottom = 1 - (bottom * (plotHeight + verticalSpacing));

                % Creating the temperature evolution subplot with new position and size
                subplot('Position', [left bottom plotWidth plotHeight]);
                plot(times, T);
                titleStr = [materials{i}, ', ', coatings{j}, ', ', orientations{k}];
                title(titleStr);
                ylabel('Temperature (°C)');

                % Adjusting the font size to make it fit better
                set(gca, 'FontSize', 8);

                % Determining the subplot index for the comments
                commentPlotIndex = tempPlotIndex + 1;

                % Calculating the position for the comment subplot
                [left, bottom] = ind2sub([numColumns, numRows], commentPlotIndex);
                left = leftMargin + (left - 1) * (plotWidth + horizontalSpacing);
                bottom = 1 - (bottom * (plotHeight + verticalSpacing));

                % Writing the comments for each graph
                commentNumber = commentPlotIndex/2;
                
                if commentNumber == 1
                    commentStr = "It stabilizes at around 250 °C after 105k seconds, heavily absorptive";
                else 
                    if commentNumber == 2
                        commentStr = "It stabilizes at around 300 °C after 102k seconds, heavily absorptive";
                    else 
                        if commentNumber == 3
                            commentStr = "It doesn't appear to stabilize after 111k seconds, heavily absorptive";
                        else 
                            if commentNumber == 4
                                commentStr = "It doesn't appear to stabilize after 111k seconds, heavily absorptive";
                            else 
                                if commentNumber == 5
                                    commentStr = "It oscillates with a mean of 33 °C after 32k seconds, mostly absorptive";
                                else 
                                    if commentNumber == 6
                                        commentStr = "Small waver with a mean of 71 °C after 31k seconds, mostly absorptive";
                                    else 
                                        if commentNumber == 7
                                            commentStr = "Small waver with a mean of -32 °C after 46k seconds, mostly emissive";
                                        else 
                                            if commentNumber == 8
                                                commentStr = "Small waver with a mean of -19 °C after 54k seconds, mostly emissive";
                                            else 
                                                if commentNumber == 9
                                                    commentStr = "It doesn't appear to stabilize after 111k seconds, heavily absorptive";
                                                else 
                                                    if commentNumber == 10
                                                        commentStr = "It starts stabilizing at around 273 °C after 110k seconds, heavily absorptive";
                                                    else 
                                                        if commentNumber == 11
                                                            commentStr = "It doesn't appear to stabilize after 111k seconds, heavily absorptive";
                                                        else 
                                                            if commentNumber == 12
                                                                commentStr = "It doesn't appear to stabilize after 111k seconds, heavily absorptive";
                                                            else 
                                                                if commentNumber == 13
                                                                    commentStr = "It oscillates with a mean of 34 °C after 55k seconds, mostly absorptive";
                                                                else 
                                                                    if commentNumber == 14
                                                                        commentStr = "Small waver with a mean of 71 °C after 42k seconds, mostly absorptive";
                                                                    else 
                                                                        if commentNumber == 15
                                                                            commentStr = "Small waver with a mean of -31 °C after 66k seconds, mostly emissive";
                                                                        else 
                                                                            if commentNumber == 16
                                                                                commentStr = "Small waver with a mean of -18 °C after 71k seconds, mostly emissive";
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end                                               
                        
                % Creating the comment subplot with new position and size
                subplot('Position', [left bottom plotWidth plotHeight]);
                set(gca, 'visible', 'off');
                text(0.5, 0.5, commentStr, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
         
            end
        end
    end
end

function [cp, density, emissivity, absorptivity] = get_properties(material, coating)
    % Return properties based on input material and coating
    switch material
        case 'Aluminum'
            cp = 887;      % unit: J/kg/ºC
            density = 2.7e3; % unit: kg/m3
        case 'Copper'
            cp = 385;      % unit: J/kg/ºC
            density = 8.96e3; % unit: kg/m3
    end
    switch coating
        case 'Gold'
            emissivity = 0.04; 
            absorptivity = 0.25;
        case 'Silver'
            emissivity = 0.017;
            absorptivity = 0.07; 
        case 'Black'
            emissivity = 0.85;
            absorptivity = 0.9;
        case 'White'
            emissivity = 0.9; 
            absorptivity = 0.15; 
    end
end
