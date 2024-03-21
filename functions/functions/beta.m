% Henrik Sjödin 2020; henrik.sjodin@umu.se
function b = beta(T)
% Oviposition rate per female mosquito; 1/day. Jia et al. (2016)
% b = max( -15.837 * T.^2 + 1.2897 * T - 0.0163, 0 ); % Jia et al. (2016)
b = max(-0.0163 * T.^2 + 1.2897 * T - 15.837, 0); % our R-script

end