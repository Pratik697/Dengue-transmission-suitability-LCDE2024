% Henrik Sjödin 2020; henrik.sjodin@umu.se
function new_data = make_timeregular_data(data, temporal_col_index)
% 20200107
% convert irregualry spaced data to daily data, based on exel datetime
% series numbers
new_data1 = [];
new_data2 = [];
t = temporal_col_index;
d = [ round( data(:,t) ) data( : , [1:(t-1) (t+1):end] ) ];

%% take daily mean 
for eti = unique(d(:,t))'
    new_data1(end+1,:) = mean(d(d(:,t) == eti,:), 1);
end
%% make linear interpolation for missing days
s = size(new_data1,1);
for i = 1:s
    if i == s
        new_data2(end+1,:) = new_data1(i,:);
    elseif ( new_data1(i,t) + 1 ) == new_data1(i+1,t)
        new_data2(end+1,:) = new_data1(i,:);
    else
        et1 = new_data1(i,t); %gap border 1
        et2 = new_data1(i+1,t); %gap border 2
        interp_data = interp1([et1 et2], new_data1([i (i+1)],:), et1 : (et2-1));
        new_data2((end+1):(end+size(interp_data,1)),:) = interp_data;
    end
end
%% finsih
new_data = new_data2;
end