clear;
clc;

load yalefaces; % loads the 3-d array yalefaces 
% for i=1:size(yalefaces,3)
%     x = double(yalefaces(:,:,i)); 
%     imagesc(x); 
%     colormap(gray) 
%     drawnow 
%     %pause(.1) 
% %    [U, S, V] = svd(x);
% end

yalefaces_mat = double(reshape(yalefaces, [], 2414)');
x_mean = mean(yalefaces_mat);
x_mean_mat = ones(size(yalefaces_mat))* diag(x_mean);
cov_base = yalefaces_mat - x_mean_mat;
cov_mat = (cov_base' * cov_base) ./ 2414;
[U, D] = eig(cov_mat);
eig_values = sum(D);
[sort_eig_values, index] = sort(eig_values,'descend');
semilogy(sort_eig_values)
for i = 1:length(sort_eig_values)
    var_cap = sum(sort_eig_values(:, 1:i)) / sum(sort_eig_values);
    if var_cap >= .95
        break
    end
end
% .95 variation captured: 43
% % dim reduction: .9787
for i = 1:length(sort_eig_values)
    var_cap = sum(sort_eig_values(:, 1:i)) / sum(sort_eig_values);
    if var_cap >= .99
        break
    end
end
% .99 variation captured: 167
% % dim reduction: .9172
subplot(5,4, 1)
a = reshape(x_mean, 48, 42);
imagesc(a); 
colormap(gray) 
drawnow 

for i = 1:19
    subplot(5, 4, i+1);
    x = reshape(U(:, index(i)), 48, 42);
    imagesc(x); 
    colormap(gray) 
    drawnow 
end