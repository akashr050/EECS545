function [subGrad ] = subGradient( x, y, theta, lambda)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    [p, n] = size(x);
    x_new = [ones(n, 1)'; x];
    a = theta * x_new;
    slack = 1 - (y .* (a));
    b = (slack > 0);
    Ji_1 = [ 0 (lambda / n) * theta(2:end)]; 
    Ji_2 = [-y/n ; 1/n *(-[y;y]  .* x) + (lambda/n * (ones(n, 1) * theta(2:end)))'];
    subGrad = (Ji_2 * b')' + sum(1-b) * Ji_1;
end

