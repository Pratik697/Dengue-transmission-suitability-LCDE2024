% Henrik Sjödin 2020; henrik.sjodin@umu.se
function m = m_X(T, W, a, b, c, w0X, pars)

% m_L: Larval mortality rate; 1/day
% m_P Pupal mortality rate; 1/day
% m_A: Adult mortality rate; 1/day

% w0X is an on/off parameter for f, w1 is the steepness of ther sigmoid
f = 1;
if w0X == 1
    f = 1 / ( 1 + exp( pars.w1 * ( W - pars.Wc ) ) ); % Implementing catastrophic event inspired by Liu-Helmersson et al. (2019)
end
g = 1 / ( abs( a*T^2 + b*T + c ) * f );
m = min(g , 1 ); %  Jia et al. (2016). But, why limit the rate to 1?

end