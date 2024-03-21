% Henrik Sjödin 2020; henrik.sjodin@umu.se
function dataavg = data_numdayavg(t, number_of_days, datavar)
tt = max(ceil(t),1);
lag = min( tt - 1 , number_of_days - 1 );
dataavg = sum(datavar( tt - lag : tt )) / (lag + 1);
end