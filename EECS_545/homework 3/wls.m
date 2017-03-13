function [ w, b ] = wls( xtr, ytr, c)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    xtr = [ones(size(xtr, 1),1) xtr];
    theta = (xtr' * diag(c) * xtr) \ (xtr' * diag(c) * ytr);
    b = theta(1);
    w = theta(2:end);
end

