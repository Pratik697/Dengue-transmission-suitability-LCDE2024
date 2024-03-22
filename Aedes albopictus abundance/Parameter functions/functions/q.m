% Henrik Sjödin 2020; henrik.sjodin@umu.se
function f = q(W, pars)

% fraction of eggs hatching to larvae as a function of precipitation W (Liu-Helmersson 2019)
f = ( pars.q1 * W / ( pars.q0 + pars.q1 * W ) ) + pars.q2;

end