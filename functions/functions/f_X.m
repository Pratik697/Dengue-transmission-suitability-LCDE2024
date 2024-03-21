% Henrik Sjödin 2020; henrik.sjodin@umu.se
function f = f_X(T, a, b, c)

% f_E: egg hatching rate; 1/day
% f_L: Larval development rate; 1/day
% f_P: Pupal development rate; 1/day

f = a * exp( - ( ( T-b ) / c )^2 ); 

end