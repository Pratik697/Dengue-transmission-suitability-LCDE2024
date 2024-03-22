% Henrik Sjödin 2020; henrik.sjodin@umu.se
function P = photoperiod(t_excel,pars)

% Forsythe et al. (1995); Metelmann et al. (2019) 
p = 0.;
J = day(datetime(t_excel,'ConvertFrom','excel'),'dayofyear'); % Day of year
L = pars.latitude;
theta = 0.2163108 + 2 * atan( 0.9671396 * tan( 0.0086 * ( J - 186 ) ) ); % ok
phi = asin( 0.39795 * cos( theta ) );
P = 24 * ( 1 - acos( ( sin( pi * p / 180 ) + sin( pi * L / 180 ) * sin( phi ) ) ./ ( cos( pi * L / 180 ) * cos( phi ) ) ) / pi );

end