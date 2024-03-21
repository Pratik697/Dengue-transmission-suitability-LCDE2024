% Henrik Sjödin 2020; henrik.sjodin@umu.se
function mdl = fit_linear_model(data, prediction)

mdl = fitlm(data,prediction);

end