function [ w, b ] = OLS( xtr, ytr)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    xtr = [ones(size(xtr, 1),1) xtr];
    theta = (xtr' * xtr) \ (xtr' * ytr);
    b = theta(1);
    w = theta(2:end);
end