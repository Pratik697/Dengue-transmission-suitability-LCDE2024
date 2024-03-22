% Henrik Sjödin 2020; henrik.sjodin@umu.se
function z = z1(Tavg, Davg, t_excel, pars)

%%%% Diapause criteria

%%% conditional form (Jia et al. 2016)
% if Tavg < 21 & Davg < 13.5 % 21 degrees C and 13.5 hours daylight
%     z = 1;
% else
%     z = 0;
% end

J = day(datetime(t_excel,'ConvertFrom','excel'),'dayofyear'); % Day of year

dP = diff(photoperiod([t_excel-1 t_excel+1],pars))/2;
%%% sigmoid formulation
% fJ = pars.r_A ./ ( 1 + exp( - pars.z_sig_steepness * ( J - 365/2 ) ) ); % force diapausing only in fall (approaching winter)
fJ = pars.r_A ./ ( 1 + exp( pars.z_sig_steepness * ( dP ) ) ); % force diapausing only in fall (based on derivative of photoperiod)

fT = 1 ./ ( 1 + exp( pars.z_sig_steepness * ( Tavg - 21 ) ) );
fD = 1 ./ ( 1 + exp( pars.z_sig_steepness * ( Davg - pars.CPP_A ) ) );

%z = f.J.*fT.*fD; % Combination of Jia et al. (2016) and Metelmann et al. (2019) 
z = fJ.*fD; % Metelmann et al. (2019) (i.e., no dependence on temperature)
end