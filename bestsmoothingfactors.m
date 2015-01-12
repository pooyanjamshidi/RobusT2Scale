function [alpha,gamma]=bestsmoothingfactors(data)
% ------------------------------------------------------------------------
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The script finds the best alpha and gamma for double exponential
% smoothing: % ? is the data smoothing factor, 0 < ? < 1, and ? is the trend smoothing factor, 0 < ? < 1.
% ------------------------------------------------------------------------


% lenght of the observed data at runtime
n = length(data);

% initialize a range for possible values for alpha and gamma smoothing
% factors

alphas = 0.1 : 0.005 : 0.4;
gammas = 0.7 : 0.005 : 1;

na = length(alphas);
ng = length(gammas);

% we put the prediction errors here
mse = zeros(na, ng);
ia = 1;
for a=alphas
    ig = 1;
    for g=gammas
        [s, b] = doubleSmoothed(data, a, g);
        %         we measure the prediction error here
        mse(ia, ig) = meanSquaredError(data(2:n), s(1:n-1) + b(1:n-1));
        ig = ig + 1;
    end
    ia = ia + 1;
end

% find the minimum index of the prediction error
[M,I]=min(mse(:));

% calculate the subscriptions for the minimum value in the mse matrix
[r,c]=ind2sub(size(mse),I);

% find the best alpha and gamma
alpha=alphas(r);
gamma=gammas(c);

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

function mse = meanSquaredError(x,y)
% Calculates the mean squared error between two vectors

mse = mean((x-y).*(x-y));
end
