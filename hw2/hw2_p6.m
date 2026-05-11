%% Problem 6
clc; clf; clear; close all;

%--------------------------------------------------------------
% Helper functions
%--------------------------------------------------------------

%--------------------------------------------------------------
% generate_random_samples
%
% Generates M random samples (simulating M trials) from the
% possible input values with assigned probabilities.
% 
% of the transfer function.
% Parameters:
%   M - Number of trials (number of output samples)
%   x - Vector of input values that the RV can take
%   p - Vector with probability of each of the input value
%--------------------------------------------------------------

function [x_out] = generate_random_samples(M, x, p)
  % Sanity check(s)
  if (M <= 0)
      error('Invalid M passed: %d', M);
  end

  if size(x) ~= size(p)
    error('Dimensions of x and p should be the same');
  end

  if ~isvector(x) || ~isvector(p)
    error('x and p should be either row or column vectors');
  end

  len = length(p);
  x_out = zeros(M, 1);

  for i = 1 : M
    u = rand(1, 1);

    if (u <= p(1))
        x_out(i) = x(1);
        continue;
    end
    for j = 2 : len
        if (u > p(j-1)) && (u <= p(j-1) + p(j))
            x_out(i) = x(j);
        end
    end
  end
end

NUM_SAMPLES = 100000;

Fs_A = 1; % Sampling rate = 1 Hz at A
Fs_B = 8; % Sampling rate = 8 Hz at B

x_A = generate_random_samples(NUM_SAMPLES, [-1 1], [0.5 0.5]);

[S_A, f] = periodogram(x_A, [], [], Fs_A, 'centered');
avg_psd_A = mean(S_A);

figure;
plot(f, S_A, 'DisplayName', 'Estimated PSD');
hold on;
plot( ...
  [-Fs_A/2, Fs_A/2], [avg_psd_A, avg_psd_A], 'r', ...
  'LineWidth', 2, 'DisplayName', ...
  sprintf('Estimated mean PSD: %.4f', avg_psd_A));
hold off;
xlim([1.5 * -Fs_A/2, 1.5 * Fs_A/2]);
title(sprintf('PSD at A with %d samples', NUM_SAMPLES));
xlabel('Frequency (Hz)'); ylabel('PSD (W/Hz)');
grid on; grid minor; axis('padded');
legend;

clear f;
SCALE_FACTOR = 8;
x_B = zeros(NUM_SAMPLES * SCALE_FACTOR, 1);

% Upscale/insert the 0s
x_B(1 : SCALE_FACTOR : end) = x_A;

[S_B, f] = periodogram(x_B, [], [], Fs_B, 'centered');
avg_psd_B = mean(S_B);

figure;
plot(f, S_B, 'DisplayName', 'Estimated PSD');
hold on;
plot( ...
    [-Fs_B/2, Fs_B/2], [avg_psd_B, avg_psd_B], 'r', ...
    'LineWidth', 2, 'DisplayName', ...
    sprintf('Estimated mean PSD: %.4f', avg_psd_B));
hold off;
xlim([1.5 * -Fs_B/2, 1.5 * Fs_B/2]);
title(sprintf('PSD at B with %d samples', NUM_SAMPLES));
xlabel('Frequency (Hz)'); ylabel('PSD (W/Hz)');
grid on; grid minor; axis('padded');
legend;

clear f;
h_srrc = rcosdesign(0.25, 10, 8, 'sqrt');

% Normalize
h_srrc = h_srrc / sqrt(sum(h_srrc.^2));

x_C = filter(h_srrc, 1, x_B);
[S_C, f] = periodogram(x_C, [], [], Fs_B, 'centered');

figure;
plot(f, S_C, 'DisplayName', 'Estimated PSD');
hold on;
H_freq = abs(fftshift(fft(h_srrc, length(f)))).^2;
plot( ...
  f, avg_psd_B * H_freq, 'r', 'LineWidth', 2, ...
  'DisplayName', 'Theoretical SRRC Shape');
hold off;
xlim([1.5 * -Fs_B/2, 1.5 * Fs_B/2]);
title(sprintf('PSD at C with %d samples', NUM_SAMPLES));
xlabel('Frequency (Hz)'); ylabel('PSD (W/Hz)');
grid on; grid minor; axis('padded');
legend;

clear f H_freq;
x_D = filter(h_srrc, 1, x_C);
[S_D, f] = periodogram(x_D, [], [], Fs_B, 'centered');

figure;
plot(f, S_D, 'DisplayName', 'Estimated PSD');
hold on;
H_freq = abs(fftshift(fft(h_srrc, length(f)))).^4;
plot( ...
    f, avg_psd_B * H_freq, 'r', 'LineWidth', 2, ...
    'DisplayName', 'Theoretical SRRC Shape');
hold off;
xlim([1.5 * -Fs_B/2, 1.5 * Fs_B/2]);
title(sprintf('PSD at D with %d samples', NUM_SAMPLES));
xlabel('Frequency (Hz)'); ylabel('PSD (W/Hz)');
grid on; grid minor; axis('padded');
legend;

clear f;
% Downsample by a factor of 8
x_E = x_D(1 : SCALE_FACTOR : end); 

% Calculate PSD at Point E
[S_E, f] = periodogram(x_E, [], [], Fs_A, 'centered');
avg_psd_E = mean(S_E);

figure;
plot(f, S_E, 'DisplayName', 'Estimated PSD at E');
hold on;
plot( ...
  [-Fs_A/2, Fs_A/2], [avg_psd_E, avg_psd_E], 'r', ...
  'LineWidth', 2, 'DisplayName', ...
  sprintf('Mean PSD: %.4f', avg_psd_E));
hold off;
xlim([1.5 * -Fs_A/2, 1.5 * Fs_A/2]);
title(sprintf('PSD at E (downsampled by %d)', SCALE_FACTOR));
xlabel('Frequency (Hz)'); ylabel('PSD (W/Hz)');
grid on; grid minor; axis('padded');
legend;
