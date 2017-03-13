clear all;
close all;
clc;

load bodyfat_data.mat;

% x_new = [ones(248, 1) X];
xtr = X(1:150, :);
ytr = y(1:150, :);

xtst = X(151:end, :);
ytst = y(151:end, :);

x_mean = mean(xtr);
y_mean = mean(ytr);

xtr_new = bsxfun(@minus, xtr, mean(xtr));
ytr_new = ytr - mean(ytr);

[n, p] = size(xtr_new);
lambda = 10;
w = (xtr_new' * xtr_new +  150* lambda * eye(p)) \ (xtr_new' * ytr_new);
% estimated parameters
%     0.6487
%    -0.0632

b = mean(ytr) - mean(xtr) * w
%    -34.0834

tst_error = mean((ytst - (xtst * w) - b).^2);
% 21.4859

% predicted response at x = [100 100]
pred = [100 100] * w + b;
% 24.4581

