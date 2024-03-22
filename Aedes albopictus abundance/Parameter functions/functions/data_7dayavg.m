% Henrik Sjödin 2020; henrik.sjodin@umu.se
function dataavg = data_7dayavg(t, datavar)
tt = max(ceil(t),1);
lag = min( tt - 1 , 6 );
dataavg = sum(datavar( tt - lag : tt )) / (lag + 1);
end