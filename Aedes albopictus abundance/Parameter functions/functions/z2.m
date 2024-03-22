% Henrik Sjödin 2020; henrik.sjodin@umu.se
function z = z2(Tavg, Davg, pars)

%%%% Hatching rate of diapuse eggs (Current implementation is based on Metelmann et al. 2019) 

%%% conditional form (Jia et al. 2016)
% if Tavg > 10.5 & Davg > 10.25 % 10.5 degrees C and 10.25 hours daylight
%     z = 1;
% else
%     z = 0;
% end

%%% sigmoid formulation
fT = 1 ./ ( 1 + exp( - pars.z_sig_steepness * ( Tavg - pars.CTT_S ) ) );
fD = 1 ./ ( 1 + exp( - pars.z_sig_steepness * ( Davg + pars.CPP_S ) ) );
z = pars.r_S * fT .* fD;
end