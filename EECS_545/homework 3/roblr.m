function [ w_rob b_rob ] = roblr( x, y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [n p] = size(x);
    
    xtr = [ones(n, 1) x];
    ytr = y;
    iter = 0;
    theta = zeros(p+1, 1);
    for iter = 1:50
        r = y - xtr * theta;
        repeat_term = (1+r.^2).^0.5;
        rho_old = repeat_term - 1;
        obj_old = sum(rho_old)/n;
        weight_vector = r./(repeat_term);
        [w_new, b_new] = wls(x, y, weight_vector);
        theta = [b_new w_new]';
        r_new = y - xtr *theta;
        repeat_term_new = (1+r_new.^2).^0.5;
        obj_new = sum(repeat_term_new - 1)/n;
                if abs(obj_new - obj_old) < 1e-6 
            break
        end
    end
    w_rob = w_new;
    b_rob = b_new;
end

