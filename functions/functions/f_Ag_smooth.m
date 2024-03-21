function v = f_Ag_smooth(T)

% Gestating adult development rate; 1/day

% exp_connect = @(T) exp(-20 + (log(0.01)-(-20))*T) / 0.01;
% v = exp_connect((T-9)/2) * 1/77 .* (T > 9 & T <= 11) + ...
%     (T-10)/77 .* (T > 11);

% exp_connect = @(T) exp(-10 + (log(0.01)-(-10))*T) / 0.01;
% v = exp_connect((T-8)/4) * 2/77 .* (T > 8 & T <= 10) + ...
%     (12-T)/2 .* exp_connect((T-8)/4) * 2/77 .* (T > 10 & T <= 12) + ...
%     (T-10)/2 .* (T-10)/77 .* (T > 10 & T <= 12) + ...
%     (T-10)/77 .* (T > 12); %best for group 2, not good for group 1

% v = ((T-9)/2).^2 * 1/77 .* (T > 9 & T <= 11) + ...
%     (T-10)/77 .* (T > 11); %overall best choice, good for both groups, best for group 1

v = 10^-2 + ((T-9)/2).^2 * 1/77 .* (T > 9 & T <= 11) + ...
    (T-10)/77 .* (T > 11);

% v = ((T-9)/2).^2 * 2/77 / 2.25 .* (T > 9 & T <= 12) + ...
%     (T-10)/77 .* (T > 12); 

end