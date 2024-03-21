% Henrik Sjödin 2020; henrik.sjodin@umu.se
function [tdayly, Xdayly] = make_solution_daily(t,X,data)

% I think that the function 'make_timeregular_data' can 
% substitute this function ('make_solution_daily').

T = round(t+data(1,1));
k=0;
excel_days = data(1,1):1:data(end,1) ;
Xdayly = zeros(length(excel_days),8);
tdayly = zeros(length(excel_days),1);
for i=excel_days 
    k=k+1; 
    index=max(find(T == i));    
    if isempty(index)
        index = old_index;
    end
    old_index = index;
    Xdayly(k,:) = X( index , :); 
    tdayly(k,1) = i; 
end

end