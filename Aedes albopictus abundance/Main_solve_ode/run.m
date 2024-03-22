mkdir('/Users/pratik/Desktop/Ume† Model/Code shared_by_henrik/functions/functions')
addpath(genpath('functions'))

% First load the data: X0, data, latitude, data_end_date
...

% Parameters that control if the old or new versions of the code is used
%
use_smooth_f_Ag = true; %smooth version of f_Ag
use_smooth_pars = false; %changes to pars.W0.., see main_solve_ode_system. these changes are not necessary when using the smooth versions of f_Ag and f_zdia, but they help if the smooth functions are not used
use_smooth_zdia = true; %smooth version of zdia
zdia_steepness = 20;

[t_smooth, X_smooth, data] = main_solve_ode_system(X0, data, latitude, ...
        data_end_date, use_smooth_f_Ag, use_smooth_pars, use_smooth_zdia, ...
        zdia_steepness);