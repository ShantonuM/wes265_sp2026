% Number of realizations
M = 1000000;

% Each column is a realization
x = floor(rand(10, M) + 0.5);

CXest = cov(x');

figure;
mesh(CXest);
title( ...
  sprintf('Covariance matrix visualization for M = %d realizations', M));
xlabel('Vector component RV X_i');
ylabel('Vector component RV X_i');
zlabel('Covariance');

