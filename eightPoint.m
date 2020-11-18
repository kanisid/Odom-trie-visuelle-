function[fMatrix] = eightPoint(matchedPoints1, matchedPoints2)
% Error checking
[n1, c1] = size(matchedPoints1);
[n2, c2] = size(matchedPoints2);
if((c1 ~= 2) || (c2 ~= 2))
    error('Points are not formated with correct number of coordinates.');
end
if((n1 < 8) || (n2 < 8))
    error('There are not enough points to carry out the operation.');
end

% Arrange data
p1 = transpose([matchedPoints1(1: 8, :), ones(8, 1)]);
p2 = transpose([matchedPoints2(1: 8, :), ones(8, 1)]);
%%%%%%%%%%%%
% Get the centroid
centroid = mean(p1, 2);
% Compute the distance to the centroid
dist = sqrt(sum((p1 - repmat(centroid, 1, size(p1, 2))) .^ 2, 1));
% Get the mean distance
mean_dist = mean(dist);
% Craft normalization matrix
norm1 = [sqrt(2) / mean_dist, 0, -sqrt(2) / mean_dist * centroid(1);...
           0, sqrt(2) / mean_dist, -sqrt(2) / mean_dist * centroid(2);...
           0, 0, 1]; 


% Get the centroid
centroid2 = mean(p2, 2);
% Compute the distance to the centroid
dist2 = sqrt(sum((p2 - repmat(centroid2, 1, size(p2, 2))) .^ 2, 1));
% Get the mean distance
mean_dist2 = mean(dist2);
% Craft normalization matrix
norm2 = [sqrt(2) / mean_dist2, 0, -sqrt(2) / mean_dist2 * centroid2(1);...
           0, sqrt(2) / mean_dist2, -sqrt(2) / mean_dist2 * centroid2(2);...
           0, 0, 1];

% Normalisation
p1 = norm1 * p1;
p2 = norm2 * p2;

p1 = transpose(p1 ./ repmat(p1(3, :), [3, 1]));
p2 = transpose(p2 ./ repmat(p2(3, :), [3, 1]));

x1 = p1(:, 1);
y1 = p1(:, 2);
x2 = p2(:, 1);
y2 = p2(:, 2);

% Craft matrix A
A = [x2 .* x1, x2 .* y1, x2, y2 .* x1, y2 .* y1, y2, x1, y1, ones(8, 1)];
% Perform SVD
[~, ~, V] = svd(A);
fMatrix = [V(1, 9), V(2, 9), V(3, 9); V(4, 9), V(5, 9), V(6, 9); V(7, 9), V(8, 9), V(9, 9)];
% Obtain fundamental matrix
[U, S, V] = svd(fMatrix);
fMatrix = U(:, 1) * S(1,1) * transpose(V(:, 1)) + U(:, 2) * S(2,2) * transpose(V(:, 2));
fMatrix = norm2' * fMatrix * norm1;



end