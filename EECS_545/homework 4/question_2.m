clear all;
close all;
clc;

rng(0); % in Matlab
load nuclear.mat;
lambda = .001;
theta = [1 1 1];
obj = zeros(100, 1);
for iter = 1:100
    [p, n] = size(x);
    x_new = [ones(n, 1)'; x];
    a = theta * x_new;
    slack = 1 - (y .* (a));
    obj(iter) = sum(slack(slack > 0)) / n + lambda/2 * sum(theta(2:end) .^2); 
    subGrad = subGradient(x, y, theta, lambda);
    theta = theta - 100/iter * subGrad;
    % stopping criteria
    if obj(iter) < 1
        break
    end
end

plot(obj(1:iter))
