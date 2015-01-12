function predicted_value=predicttrend(data,number_of_forcast)
% ------------------------------------------------------------------------
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The scripts do the forecasting with double exponential smoothing
% Double exponential smoothing uses two constants and is better at
% handling trends than single exponential smoothing.
% ? is the data smoothing factor, 0 < ? < 1, and ? is the trend smoothing factor, 0 < ? < 1.
% ------------------------------------------------------------------------

% lenght of the observed data at runtime
n = length(data);

% find the best alpha and gamma smoothing factors for this data set.
% at runtime we can give this procedure a new data set based on the observed
% data points
[alpha,gamma]=bestsmoothingfactors(data);

% Here we smooth current observed data
[s, b] = doubleSmoothed(data, alpha, gamma);

% f is the vector for the predicted values ahead of time so f(1) is 1
% prediction ahead of time and f(2) is 2 predictions ahead of time, and so
% on
f = zeros(1,number_of_forcast);

% the last smoothed data points
st = s(n);
bt = b(n);

% the main magic happens here! we use the associated formula for double
% exponential smoothing

for i = 1:number_of_forcast
    f(i) = st + bt;
    st1 = st;
    % The first smoothing equation adjusts St directly for the trend of the previous period, bt, by adding it to the last smoothed value, St.
    % This helps to eliminate the lag and brings St to the appropriate base of the current value.
    st = alpha*f(i) + (1-alpha)*(st+bt);
    % The second smoothing equation then updates the trend, which is expressed as the difference between the last two values.
    bt = gamma*(st-st1) + (1-gamma)*bt;
end

predicted_value=f(number_of_forcast);

end

function [s, b] = doubleSmoothed(data, alpha, gamma)
% Calculates double exponentially smoothed data with weight parameters
% alpha and gamma.

n = length(data);
s = zeros(1,n);
b = zeros(1,n);
s(1) = data(1);
b(1) = data(2) - data(1);
for i = 2:n
    % The first smoothing equation adjusts Si directly for the trend of the previous period, bi-1, by adding it to the last smoothed value, Si-1.
    % This helps to eliminate the lag and brings Si to the appropriate base of the current value.
    s(i) = alpha*data(i) + (1-alpha)*(s(i-1)+b(i-1));
    % The second smoothing equation then updates the trend, which is expressed as the difference between the last two values.
    b(i) = gamma*(s(i)-s(i-1)) + (1-gamma)*b(i-1);
end
end
