clc;
clear;

% load image 
y = imread('mandrill.tiff');
% extract blocks 
M = 2; % block side-length
k = 100;
n = numel(y)/(3*M*M); % number of blocks 
d = size(y,1); % image length/width

c=0; % counter 
x = zeros(n,3*M*M); 
for i=1:M:d % loop through blocks 
    for j=1:M:d
        c = c+1; 
        x(c,:) = reshape(y(i:i+M-1,j:j+M-1,:),[1,M*M*3]); 
    end
end

% K means algorithm 
rng(0);
perm = randperm(n);
centroids = x(perm(1:k), :);
obj_vec = zeros(500, 1);
for iter = 1:500
    dist_frm_centroids = dist2(x, centroids);
    [min_dist, cluster_map] = min(dist_frm_centroids,[], 2);
    obj = mean(min_dist);
    obj_vec(iter) = obj;
    centroids_old = centroids;
    centroids = zeros(100, 12);
    for i = 1:k
        centroids(i, :) = mean(x(find(cluster_map == i),:));
    end  
    if norm(centroids - centroids_old) < 0.01 
        break
    end
end

obj_vec = obj_vec(1:iter);
plot(1:iter, obj_vec)

x_new = centroids(cluster_map,:);

y_new = zeros(512, 512, 3);
c = 0;
for i=1:M:d % loop through blocks 
    for j=1:M:d
        c = c+1; 
        y_new(i:i+M-1,j:j+M-1,:) = reshape(x_new(c, :), M, M, 3); 
    end
end

y_new = uint8(y_new);

subplot(1,2, 1)
imagesc(y)
subplot(1,2,2)
imagesc(y_new)
drawnow 

subplot(1, 1, 1)
imshowpair(y,y_new);

rel_mean_abs_error = sum(abs(y_new(:) - y(:))) / (3 * 512 * 512 * 256); 
% 0.0232

N = 512;
compression_ratio = (k * M*M*24 + log2(k) * (N*N)/(M*M))/ (N*N*24)