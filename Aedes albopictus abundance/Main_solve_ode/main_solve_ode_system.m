% Henrik Sjödin 2020; henrik.sjodin@umu.se
function [t, X, data] = main_solve_ode_system(X0, data, latitude, ...
    data_end_date, use_f_Ag_smooth, use_pars_smooth, use_zdia_smooth, ...
    zdia_steepness)

% This is the main function solving a defined ode system, with initial condition 'X0', and based on
% 'data'.'data_end_date' is used to match the end date of the climate data
% with that of the start date of sub-seasonal forcast data.

%%%% notes:
% (1) beta(T) i Jia et al. 2016 is always less than zero. In a previous R-script
% coefficient 'a' is switched with 'c', and beta(T) is sometimes larger than 0.
%
% (2) Ode solver has problems to meet integration tolerances. Try formulate
%     z1() etc. as a smooth (sigmoid) function instead of step-functions as in Jia et al. 2016.

addpath('./functions/');
if ~isempty(data_end_date)
    [row col] = find(data(:,1) == data_end_date); % given that time is index 1
    data = data(1:row,:);
    clear row col
end

fprintf('ODE: ')
pars = pars_albopictus(latitude, zdia_steepness);
if use_pars_smooth
    pars.w0L = 1; pars.w0P = 1; pars.w0A = 1;
    fprintf('pars w0L ')
end
if ~isempty(X0)
    pars.X0 = X0;
end
options = odeset('NonNegative',1:length(pars.X0),'RelTol',1e-2);

if isempty(pars.tspan)
    pars.tspan = [0 size(data,1)-1];%[0 size(data,1)-2]
end

if ~use_f_Ag_smooth && ~use_zdia_smooth
    [t, X] = ode15s(@(t, X) albopictus_equation_system(t, X, pars, data), pars.tspan, pars.X0,options);
    fprintf('regular')
elseif use_f_Ag_smooth && ~use_zdia_smooth
    [t, X] = ode15s(@(t, X) albopictus_equation_system__smooth_f_Ag(t, X, pars, data), pars.tspan, pars.X0,options);
    fprintf('smooth f_Ag')
elseif ~use_f_Ag_smooth && use_zdia_smooth
    [t, X] = ode15s(@(t, X) albopictus_equation_system__smooth_zdia(t, X, pars, data), pars.tspan, pars.X0,options);
    fprintf('smooth zdia')
elseif use_f_Ag_smooth && use_zdia_smooth
    [t, X] = ode15s(@(t, X) albopictus_equation_system__smooth_f_Ag_and_zdia(t, X, pars, data), pars.tspan, pars.X0,options);
    fprintf('smooth f_Ag and zdia')
end
fprintf('\n')

end