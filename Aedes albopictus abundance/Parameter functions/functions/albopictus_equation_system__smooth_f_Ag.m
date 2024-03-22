% Henrik Sjödin 2020; henrik.sjodin@umu.se
function dX = albopictus_equation_system__smooth_f_Ag(t, X, pars, data)
%%% AVERAGING DATA (TEMPORARY) !!!!!!
% data(:,2) = ones(size(data(:,2))) * 10;%*mean(data(:,2),'omitnan');
% data(:,3) = ones(size(data(:,3))) * 20;%*mean(data(:,3),'omitnan');
%%%
prec_data_index = pars.prec_data_index;
temp_data_index = pars.temp_data_index;

% Variable notation as in Jia et al. (2016) 
E0 = X(1); Ed = X(2); L = X(3); P = X(4); 
Aem = X(5); Ab = X(6); Ag = X(7); Ao = X(8);

W = data_lin_intpolval(t,data(:,prec_data_index));
T = data_lin_intpolval(t,data(:,temp_data_index));

% Wavg = data_7dayavg(t, data(:,prec_data_index)); 
Wavg = data_numdayavg(t, pars.num_days_in_avg_W, data(:,prec_data_index)); 
% Tavg = data_7dayavg(t, data(:,temp_data_index)); 
Tavg = data_numdayavg(t, pars.num_days_in_avg_T, data(:,temp_data_index)); 
Davg = photoperiod(t+data(1,1), pars); % not 7 day avg., but photoperiod of the day. However, does it really matter in this case? 
% Davg = 12.5;
fE = f_X(T,pars.a_fE, pars.b_fE, pars.c_fE);
fL = f_X(T,pars.a_fL, pars.b_fL, pars.c_fL);
fP = f_X(T,pars.a_fP, pars.b_fP, pars.c_fP);

% w0A = pars.w0A; w0L = pars.w0L; w0P = pars.w0P; % Catastrphy (heavy rain) on/off parameters
mA = m_X(T,W, pars.a_mA, pars.b_mA, pars.c_mA, pars.w0A, pars); 
mL = m_X(T,W, pars.a_mL, pars.b_mL, pars.c_mL, pars.w0L, pars); 
mP = m_X(T,W, pars.a_mP, pars.b_mP, pars.c_mP, pars.w0P, pars); 

kL = k_L(Wavg,pars);
kP = k_P(Wavg, pars);

z_dia = zdia(Tavg);
f_dia = pars.a2 * fE;
m_dia = pars.a1 * pars.mE;
B = beta(T);

Z1 = z1(Tavg, Davg, t + data(1,1), pars);
Z2 = z2(Tavg, Davg, pars);


% Equation 5 in Jia et al. (2016)
dE0 = ( 1 - Z1 ) * B * Ao - ( pars.mE + fE ) * E0;
dEd = Z1 * B * Ao - ( m_dia + Z2 * f_dia ) * Ed;
dL = ( fE * E0 + Z2 * f_dia * Ed ) * q(Wavg, pars) - ( mL * ( 1 + L / kL) + fL ) * L; % q(W), (and kL as afunction of precipitation), from Liu-Helmersson et al. (2019)
dP = fL * L - ( mP + fP ) * P;
dAem = 1*(fP * pars.sigma * exp( - pars.mu_em * (1 + P / kP) ) * P - ( mA * z_dia * pars.gamma_Aem ) * Aem);
% dAb = 1*(z_dia * ( pars.gamma_Aem * Aem + pars.gamma_Ao * Ao ) - ( mA + pars.mu_r + z_dia * pars.gamma_Ab ) * Ab);
% dAg = 1*(z_dia * pars.gamma_Ab * Ab - ( mA + f_Ag_smooth(T) ) * Ag);
% dAo = 1*(f_Ag_smooth(T) * Ag - ( mA + pars.mu_r + z_dia * pars.gamma_Ao ) * Ao);

influx = 10;
if t < 365
    dAb = 1*(z_dia * ( pars.gamma_Aem * Aem + pars.gamma_Ao * Ao ) - ( mA + pars.mu_r + z_dia * pars.gamma_Ab ) * Ab) + influx;
    dAg = 1*(z_dia * pars.gamma_Ab * Ab - ( mA + f_Ag_smooth(T) ) * Ag) + influx;
    dAo = 1*(f_Ag_smooth(T) * Ag - ( mA + pars.mu_r + z_dia * pars.gamma_Ao ) * Ao) + influx;
else
    dAb = 1*(z_dia * ( pars.gamma_Aem * Aem + pars.gamma_Ao * Ao ) - ( mA + pars.mu_r + z_dia * pars.gamma_Ab ) * Ab);
    dAg = 1*(z_dia * pars.gamma_Ab * Ab - ( mA + f_Ag_smooth(T) ) * Ag);
    dAo = 1*(f_Ag_smooth(T) * Ag - ( mA + pars.mu_r + z_dia * pars.gamma_Ao ) * Ao);
end

dX(:,1) = [dE0; dEd; dL; dP; dAem; dAb; dAg; dAo];

end