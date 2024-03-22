% Henrik Sjödin 2020; henrik.sjodin@umu.se
function mdl = fit_tsdata_to_graphical_tsdata(tsdata, ts_exceltime, climate_data, G, exceltimewindow, ywindow, abundance_var_name,  fignum)

tstime = round(ts_exceltime);
xtw = exceltimewindow;
%% Convert graphical Breteau data ot numerical data
[N_unscaled, N, Gproc] = graphic2numeric(G,[exceltimewindow(1) exceltimewindow(2) ywindow(1) ywindow(2)],fignum+1);
N = round(N); % round to provide a per-day resolution
%% Remove duplicate time stamps (as a potential outcome from the previous rounding)
Nprev = N(1,:);
Ntemp = N;
for i = 2:size(N,1)
    if N(i,1) == Nprev
        Ntemp(i,:) = [];
    end
    Nprev = N(i,:);
    
end
N = Ntemp;
clear Ntemp Nprev
%% Pick time window in predicted time-series that is relevant to data time-window and round to per-day resolution

% find(median(round(tstime)) == xtw(1));

D0 = tsdata(median(find(tstime == xtw(1))):median(find(tstime == xtw(2))));
T0 = round(tstime(median(find(tstime == xtw(1))):median(find(tstime == xtw(2)))));
ClimTime0 = climate_data(:,1);
ClimTime = climate_data(median(find(ClimTime0 == xtw(1))):median(find(ClimTime0 == xtw(2))),1);
PrecData = climate_data(median(find(ClimTime0 == xtw(1))):median(find(ClimTime0 == xtw(2))),2);
TempData = climate_data(median(find(ClimTime0 == xtw(1))):median(find(ClimTime0 == xtw(2))),3);

%% Remove duplicate time staps (caused by the rounding) 
k=0;
T_old = 0;
for i = 1:length(T0) % sort out duplicate times
    T_this = T0(i);
    if T_this ~= T_old
        k=k+1;
        T(k,1) = T0(i,1);
        D(k,1) = D0(i,1);
    end
    T_old = T_this;
end
%% Temporally align data points in data and prediction lists 
rNt = round(N(:,1)); % rounding step (uneccesary)
for i = 1:length(T)
    Nind = median(find( rNt == T(i)));
    if isnan(Nind)
        k=0;
        while isnan(Nind) == true
            k=k+1;
            Nind = median(find(rNt == T(i) + k));
        end
    end
  
    if Nind < length(N(:,1))
        v = ( ( N(Nind,2) - N(Nind+1,2) ) * T(i) + N(Nind,1) * N(Nind+1,2) - N(Nind+1,1) * N(Nind,2) ) / ( N(Nind,1) - N(Nind+1,1) );
        N_aligned(i,1) = T(i);
        N_aligned(i,2) = v;
        T_aligned(i,1) = T(i);
        D_aligned(i,1) = D(i);
    end
end
%% Apply moving average on predicted time series to mimic temporal resulotion in data, and
%  perform normalization of prediction and data within a narrowed time window where
%  edge effect from moving averaging are insignificant

mov_mean_win = 28; %(days)

D_aligned = movmean(D_aligned,mov_mean_win,'SamplePoints',T_aligned,'Endpoints','shrink');

twindow_indices = (mov_mean_win+1):length(N_aligned)-mov_mean_win;
x = N_aligned(twindow_indices,2)/max(N_aligned(twindow_indices,2));
y = D_aligned(twindow_indices,1)/max(D_aligned(twindow_indices,1));
%% find best alignmend of time series data (for visual comparison (irrelevant to correlation)), and as the scaling is anyway arbitrary
fun = @(z)sum((x-z*y).^2);
z = fminbnd(fun,0.5,2);
y=z*y;
% y = movmean(y,28,'SamplePoints',T_aligned(twindow_indices,1),'Endpoints','shrink');
% y = y/max(y);
%% Test correlation
[R,P] = corrcoef(x,y); % Test correlation
%% Plot climate and abundance time series
figure(fignum)
clf(fignum)
subplot(4,1,1)
plot(datetime(ClimTime(twindow_indices),'ConvertFrom','excel'),PrecData(twindow_indices))
ylabel('Precipitation (mm/day)')
subplot(4,1,2)
plot(datetime(ClimTime(twindow_indices),'ConvertFrom','excel'),TempData(twindow_indices))
ylabel('Temperature (C)')
subplot(4,1,3)
plot(datetime(N_aligned(twindow_indices,1),'ConvertFrom','excel'),x,'-','LineWidth',1)
hold on
plot(datetime(T_aligned(twindow_indices),'ConvertFrom','excel'), y,'-','LineWidth',2)
ylim([0 1.2])
xlabel('Time')
ylabel('Abundance metric')
legend('Data (Normalized Breteau index)', ['Pred. (Normalized ' abundance_var_name ' abundance)'])
text(0.1,0.9,['Corr.: ' num2str(round(R(2,1),2)) '  |  p-value: ' num2str(round(P(2,1),3))],'units','normalized')
text(0.1,0.8,['Sliding window: ' num2str(mov_mean_win) ' days'],'units','normalized')

%% Make linear model to test model fidelity to data
% mdl = fit_linear_model(x, y);
mdl = fitlm(x,y);% make linear model to test model fidelity to data
%% Plot linear model
subplot(4,1,4)
% scatter(x,y);
% hold on
mdl.plot
ylim([0 1])
xlabel('Data')
ylabel('Model')
text(0.1,0.9,['Adjusted R-squared: ' num2str(round(mdl.Rsquared.Adjusted,2))],'units','normalized')

    
end
