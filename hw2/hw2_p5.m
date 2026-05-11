%% Problem 5
clc; clf; clear; close all;

N_vals = [10, 100, 1000, 10000, 100000, 1000000];
data = cell(1, length(N_vals));

for i = 1 : length(N_vals)
    data{i} = normrnd(10, 2, 1, N_vals(i));
end

figure(1);
sgtitle('Empirical vs Theoretical PDF')

for i = 1 : length(N_vals)
  x = data{i};
  N = N_vals(i);

  % Plot empirical PDF from -2 to 16 (+- 6 standard deviations around the
  % mean
  bins_num = ceil(sqrt(N));
  edges = linspace(min(x), max(x), bins_num + 1);
  bin_width = edges(2) - edges(1);
  counts = zeros(1, bins_num);
  bin_centers = zeros(1, bins_num);

  for j = 1 : bins_num
    % Count number of samples in each bin
    counts(j) = sum(x >= edges(j) & x < edges(j+1));
    bin_centers(j) = (edges(j) + edges(j+1)) / 2;
  end

  % Normalize
  emp_pdf = counts / (N * bin_width);

  subplot(3, 3, i);
  plot(bin_centers, emp_pdf);
  title(sprintf('N = 10^{%d} samples', log10(N)));
  xlabel('x'); ylabel('PDF');
  grid on; grid minor; axis('padded');
end

clear x;
x = linspace(-2, 22, 1000);
%theoretical_pdf = (1 / (sqrt(2 * pi * 4))) * exp(-(x - 10).^2 / 8);
theoretical_pdf = normpdf(x, 10, 2);

subplot(3, 3, 8);
plot(x, theoretical_pdf);
title('Theoretical');
xlabel('x'); ylabel('PDF');
grid on; grid minor; axis('padded');

figure(2);
sgtitle('Empirical vs Theoretical CDF')

for i = 1 : length(N_vals)
    x = data{i};
    N = N_vals(i);

    % Plot empirical CDF from -2 to 22 (+- 6 standard deviations around the
    % mean
    subplot(3, 3, i);
    plot(sort(x), (1 : N) / N);
    title(sprintf('N = 10^{%d} samples', log10(N)));
    xlabel('x'); ylabel('CDF');
    grid on; grid minor; axis('padded');
end

clear x;
x = linspace(-2, 22, 1000);
theoretical_cdf = normcdf(x, 10, 2);

subplot(3, 3, 8);
plot(x, theoretical_cdf);
title('Theoretical');
xlabel('x'); ylabel('CDF');
grid on; grid minor; axis('padded');