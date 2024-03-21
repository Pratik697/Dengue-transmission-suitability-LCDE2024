% Henrik Sjödin 2020; henrik.sjodin@umu.se
function z = zdia(Tavg)
% Look in Jia et al. (2019) for info on this. Temperature in Reunion data
% does anyway not go below 9.5 ºC
if Tavg < 9.5
    z = 0;
else
    z = 1;
end

end