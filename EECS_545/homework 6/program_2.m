clear all; 
close all;
clc;
load diabetes_scaled.mat;

% Creating test and train data sets
X_tr = X(1:500,:);
X_tt  = X(501:end,:);
Y_tr = y(1:500);
Y_tt  = y(501:end);

grid_sigma = 2.^(0:5);
grid_C = 2.^(6:11);
tol = 0.01;
[n, p] = size(X_tr);
% Cauchy kernel
cauchy_kernel = @(u,v,sigma) (1 + dist2(u, v)/(sigma^2)) .^-1;
    
num_sv = zeros(length(grid_sigma), length(grid_C));
CV_error_grid = zeros(length(grid_sigma), length(grid_C));

for i = 1:length(grid_sigma)
    grid_sigma_iter = grid_sigma(:,i);
    for j = 1:length(grid_C)
        grid_C_iter = grid_C(:,j);
            CV_error_iter = 0;
            for k = 1:5
                ind = (k-1)*100 + 1: k*100;

                X_tr_iter = X_tr;
                X_tr_iter( ind,:) = [];
                X_CV_iter = X_tr(ind,:);

                y_tr_iter = Y_tr;
                y_tr_iter(ind,:) = [];
                y_CV_iter = Y_tr(ind,:);

                kmat_tr = cauchy_kernel(X_tr_iter, X_tr_iter, grid_sigma_iter);
                [alpha, bias] = smo(kmat_tr, y_tr_iter', grid_C_iter, tol);
                kmat_CV = cauchy_kernel(X_CV_iter, X_tr_iter, grid_sigma_iter);
                y_pred = sign(kmat_CV * (y_tr_iter .* alpha') + bias);
                CV_error_iter = 1 - sum((y_pred == y_CV_iter))/100 + CV_error_iter;
            end
            CV_error_grid(i, j) = CV_error_iter / 5;
    end
end

[min_error, ind] = min(CV_error_grid(:));
[m,n] = ind2sub(size(CV_error_grid),ind);

sigma_opt = grid_sigma(m); %4
C_opt = grid_C(n); %512

% Selected parameters: (sigma, C) :: (4, 512) 
% CV error: min_error :: 0.2480

% Final model
kmat_tr = cauchy_kernel(X_tr, X_tr, sigma_opt);
[alpha, bias] = smo(kmat_tr, Y_tr', C_opt, tol);
kmat_tt = cauchy_kernel(X_tt, X_tr, sigma_opt);
y_pred = sign(kmat_tt * (Y_tr .* alpha') + bias);
error_tt = 1 - sum((y_pred == Y_tt))/size(Y_tt, 1);
% test error :: 0.182
500 - sum(alpha == 0);
%number of support vectors :: 342
