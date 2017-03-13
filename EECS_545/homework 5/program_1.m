clear all; 
close all;
clc;
load bodyfat_data.mat;

% Creating test and train data sets
X_train = X(1:150,:);
X_test  = X(151:end,:);
Y_train = y(1:150);
Y_test  = y(151:end);

sigma = 1.5;
lambda = 0.003;
[n, p] = size(X_train);

%%%%%%%%%%%%% PART D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_train = exp(-1/(2 * sigma ^ 2) * dist2(X_train, X_train));
O_mat   = ones(150, 150) * 1/n;
K_train_tilda = K_train - K_train * O_mat - O_mat * K_train + O_mat * K_train * O_mat;

[m, p] = size(X_test);
K_test = exp(-1/(2 * sigma ^ 2) * dist2(X_train, X_test));
O_mat_test = ones(n, m) * 1/n;
K_test_tilda = K_test - K_train * O_mat_test - O_mat * K_test + O_mat * K_train * O_mat_test;

% train mean squared error 
u = n * lambda;
y_mean = mean(Y_train);
B = (eye(n) - (K_train_tilda + u * eye(n)) \ K_train_tilda);
y_mean_vec = ones(n, 1) * y_mean;
Y_train_centered = Y_train - y_mean_vec;
y_train_pred = y_mean_vec + K_train_tilda' * B * Y_train_centered / u;
mean_squared_error_train = (y_train_pred - Y_train)' * (y_train_pred - Y_train) / n; % 10.3465

% test mean squared error
y_mean_vec = ones(m, 1) * y_mean;
y_test_pred = y_mean_vec + K_test_tilda' * B * Y_train_centered / u;
mean_squared_error_test = (y_test_pred - Y_test)' * (y_test_pred - Y_test) / m; % 49.2640

% b
x_mean = mean(X_train, 1);
K_b = exp(-1/(2 * sigma ^ 2) * dist2(X_train, x_mean));
B_b = (eye(n) - K_train_tilda * inv(K_train_tilda + u * eye(n)));
k_b_xmean = K_b - ones(n,1);
b = y_mean - Y_train_centered' * B_b * K_b / u; % 15.9750


%%%%%%%%%%%%% PART E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_train = exp(-1/(2 * sigma ^ 2) * dist2(X_train, X_train));
K_test = exp(-1/(2 * sigma ^ 2) * dist2(X_train, X_test));
B = (eye(n) - (K_train + u * eye(n)) \ K_train);
y_train_pred = K_train' * B * Y_train / u;
MSE_train_off = (y_train_pred - Y_train)' * (y_train_pred - Y_train) / n; % 16.4636

% test mean squared error
y_test_pred = K_test' * B * Y_train / u;
MSE_test_off = (y_test_pred - Y_test)' * (y_test_pred - Y_test) / m; % 161.0847
