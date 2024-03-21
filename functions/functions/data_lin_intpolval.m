% Henrik Sjödin 2020; henrik.sjodin@umu.se
function v = data_lin_intpolval(t, datavariable)
t1 = floor(t) + 1;

if t1 < size(datavariable,1)  
    t2 = t1 + 1;%ceil(t) + 1
    y1 = datavariable(t1);
    try
        y2 = datavariable(t2);
    catch
        warning('Error in interpolation function data_lin_intpolval()')
        t
        size(datavariable,1)
    end

%     Henrik's form :)  v = ( ( y1 - y2 ) * (t + 1) + t1 * y2 - t2 * y1 ) / ( t1 - t2 );   

%     Conventional form: 
    v = y1 + (y2 - y1) * (t + 1 - t1) / (t2 - t1);
else
    
     v = datavariable(t1);
end
end