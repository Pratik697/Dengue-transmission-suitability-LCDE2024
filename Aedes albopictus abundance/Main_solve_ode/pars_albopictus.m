% Henrik Sjödin 2020; henrik.sjodin@umu.se
function p = pars_albopictus(latitude, zdia_steepness)

%% Native parameter values and settings
p.prec_data_index = 2;
p.temp_data_index = 3;
p.tspan = [];
% p.X0 = [250000 250000 250000 250000 50000 50000 50000 50000]*1;
p.X0 = [0 0 0 0 0 1 1 1]*1e3;

p.latitude = latitude;
p.w1 = 20; % Steepness of catastrophic precipitation response
p.z_sig_steepness = 20;

p.zdia_steepness = zdia_steepness;

p.w0L = 1; p.w0P = 1; p.w0A = 0; % Catastrphy (heavy rain) on/off parameters

p.K_L = 250000; % (Currently set to 250000 from Jia and "our R-script"); match this to the conditions at Reunion.
p.K_P = 250000; % (Currently set to 250000 from Jia and "our R-script"); match this to the conditions at Reunion.

p.num_days_in_avg_W = 7;
p.num_days_in_avg_T = 7;

%% Parameter values from Metelmann et al. 2019

p.CTT_S = 11.0; %critical temperature over one week in spring (degrees Celcius)
p.CPP_S = 11.25; % critical photoperiod in spring (hours)
p.CPP_A = 10.058 + 0.08965 * abs(p.latitude); % critical diapause photoperiod in autumn (hours)
p.r_A = 0.5; % 50% of eggs are diapause eggs
p.r_S = 0.1; % Diapause egg hatching rate

%% parameter values from Jia et al. (2016)
p.mE = 0.05; % Egg motality rate; 1/day
p.sigma = 0.5; % Proportion of females at emergence stage
p.mu_em = 0.1; % Emerging adults mortality rate
p.gamma_Aem = 0.4; % Emerging adult development rate; 1/day
p.gamma_Ao = 0.2; % Ovipositing adult development rate; 1/day
p.mu_r = 0.08; % Adult mortality rate related to seeking behavior; 1/day
p.gamma_Ab = 0.2; %Blood feeding adult development rate; 1/day


% Fitted coefficients for f_X and m_X (Jia et al. (2016), Table 5) 
p.a_fE = 0.507; p.b_fE = 30.85; p.c_fE = 12.82; % r-square: 0.91
p.a_fL = 0.1727; p.b_fL = 28.4; p.c_fL = 10.2; % r-square: 0.96
p.a_fP = 0.602; p.b_fP = 34.29; p.c_fP = 15.07; % r-square: 0.97
p.a_mL = -0.1305; p.b_mL = 3.868; p.c_mL = 30.83; % r-square: 0.83
p.a_mP = -0.1502; p.b_mP = 5.057; p.c_mP = 3.517; % r-square: 0.83
p.a_mA = -0.1921; p.b_mA = 8.147; p.c_mA = -22.98; % r-square: 0.93

% a1 and a2 in Jia et al. (2016)
p.a1 = 0.1;
p.a2 = 0.1;

%% parameter values from Liu-Helmersson et al. (2019)
p.c0 = 5; % [M]/larval site; production of breeding sites by rain
p.c1 = 30; % mm/day; amount od rain to produce 1/2 of the max breeding sites
p.c2 = 0.1; % [M]/larval site; rain-independent larval sites
p.q0 = 0.2; % mm/day; ammount of rain to allow 50% of eggs hatching
p.q1 = 0.02; % Capacity of eggs hatching with rain
p.q2 = 0.037; % Hatching fraction from rain independent sites
p.Wc = 30; % Critical precipitation (catastriphic event)

%% parameter values from our R-script
% p.chi_P = 250000;

end