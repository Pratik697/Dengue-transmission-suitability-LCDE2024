% Henrik Sjödin 2020; henrik.sjodin@umu.se
function k = k_L(W, pars) 
%Environmental carrying capacity of larvae 1/ha

k = pars.K_L * ( pars.c0 * W / (pars.c1 + W) ) + pars.c2; % k is equal to C(W) in Liu-Helmersson et al. (2019)

end

%Liu-Helmersson et al. (2019) Estimating Past, Present, and Future Trends
%in the Global Distribution and Abundance of the Arbovirus Vector Aedes
%aegypti Under Climate Change Scenarios. 7:148 Front. in Pub. Health