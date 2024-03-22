% Henrik Sjödin 2020; henrik.sjodin@umu.se
function v = f_Ag(T)

% Gestating adult development rate; 1/day

%For now, set directly as in "our R-script".
v = max(0,(T-10)/77);

end