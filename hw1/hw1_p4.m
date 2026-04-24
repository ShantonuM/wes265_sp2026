%% Problem 4
close all; clc; clear;

num_samples = [1e2, 1e4, 1e7];

figure;
sgtitle( ...
  'Empirical vs Theoretical CDF a standard normal distribution');

cnt = 1;
for i = num_samples
  clear x f val;
  subplot(2, 2, cnt);
  x = normrnd(0, 1, [1, i]);
  [f, val] = ecdf(x);
  plot(val, f);
  xlim([-4, 4]);
  title( ...
    sprintf('Empirical CDF with 10^{%d} samples', log10(i)));
  xlabel('x'); ylabel('Cumulative Probability');
  grid on; grid minor; axis("padded");
  cnt = cnt + 1;
end

% CDF of the theoretical distribution
subplot(2, 2, 4);
x1 = linspace(-4, 4, 1000);
f1 = normcdf(x1);
plot(x1, f1);
title('Theoretical CDF from [-4, 4]');
xlabel('x'); ylabel('Cumulative Probability');
grid on; grid minor; axis("padded");

% Part 5 - Estimate P[-1 <= X <= 1] empirically
count = 0;
for i = x
  if (i >= -1) && (i <= 1)
    count = count + 1;
  end
end

fprintf( ...
  'Empirical P[-1 <= X <= 1] = %.5f\n', ...
  count / num_samples(3));

% Part 6 - Numerical integration for the the theoretical P[-1 <= X <= 1]
fun = @(x) (1 / sqrt(2 * pi)) .* exp(-(x.^2) / 2);
fprintf( ...
  'Theoretical P[-1 <= X <= 1] = %.5f\n', ...
  integral(fun, -1, 1));
