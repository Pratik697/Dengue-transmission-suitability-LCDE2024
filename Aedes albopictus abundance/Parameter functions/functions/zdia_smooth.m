% Henrik Sjödin 2020; henrik.sjodin@umu.se
function z = zdia_smooth(Tavg, steepness)
% Look in Jia et al. (2019) for info on this. Temperature in Reunion data
% does anyway not go below 9.5 ºC
z = exp(Tavg*steepness - 9.5*steepness) ./ ...
    (exp(Tavg*steepness - 9.5*steepness) + 1);

end