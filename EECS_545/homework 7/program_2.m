clear all
close all
rng(0);
n = 200; % sample size
K = 2; % number of lines
e = [.7 .3]; % mixing weights
w = [-2 1]; % slopes of lines
b = [.5 -.5]; % offsets of lines
v = [.2 .1]; % variances
for i=1:n
x(i) = rand;
if rand < e(1);
y(i) = w(1)*x(i) + b(1) + randn*sqrt(v(1));
else
y(i) = w(2)*x(i) + b(2) + randn*sqrt(v(2));
end
end
plot(x,y,'bo')
hold on
t=0:0.01:1;
plot(t,w(1)*t+b(1),'k')
plot(t,w(2)*t+b(2),'k')

% EM algorithm
e = [.5 .5]; 
w = [1 -1]; % slopes of lines
b = [0 0]; % offsets of lines
v = repmat(var(y), 1, 2); % variances
log_likelihood = zeros(500, 1);
for iter = 1:10
    u = w' * x + b' * ones(n, 1)'; 
    w_mat = repmat(w', 1, 200); 
    x_mat = vertcat(x, x);
    y_mat = vertcat(y, y);
    v_mat = v' * ones(1, n);
    
    gaussian_pdf = normpdf(y_mat, u, sqrt(v_mat));
    e_mat = repmat(e', 1, 200);
    phi_num = e_mat .* gaussian_pdf;
    phi_dem = sum(phi_num, 1);
    phi = phi_num ./ repmat(phi_dem, 2, 1);
    log_likelihood(iter,:) = sum(log(sum(gaussian_pdf .* e_mat,1)));
    if iter ~= 1
        if abs(log_likelihood(iter-1,:) - log_likelihood(iter,:)) <= (10 ^ (-4))
            break
        end
     end
    x_new = [ones(1,n); x];
    phi_diag_1 = diag(phi(1,:));
    a1 = (inv(x_new * phi_diag_1 * x_new') * x_new * phi_diag_1 * y')';
    
    phi_diag_2 = diag(phi(2,:));
    a2 = (inv(x_new * phi_diag_2 * x_new') * x_new * phi_diag_2 * y')';
    
    b = [a1(1) a2(1)];
    w = [a1(2) a2(2)];
    u = w' * x + b' * ones(n, 1)'; 
    v = sum(phi .* ((y_mat - u) .^ 2), 2)' / n;
    e = sum(phi, 2)' / n;
end

hold on
plot(t,w(1)*t+b(1),':')
plot(t,w(2)*t+b(2),':')

hold off
subplot(1, 1, 1);
plot(1:iter, log_likelihood(1:iter,:))
