clc; clear; close all;

%-------------------------------------------------------------------------------
% Helper functions
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% generate_random_samples
%
% Generates M random samples (simulating M trials) from the possible input
% values with assigned probabilities.
% 
% of the transfer function.
% Parameters:
%   M - Number of trials (number of output samples)
%   x - Vector of input values that the random variable can take
%   p - Vector with probability of each of the input value
%-------------------------------------------------------------------------------

function [x_out] = generate_random_samples(M, x, p)
  % Sanity check(s)
  if (M <= 0)
    error("Invalid M passed: %d", M);
  end
  
  if size(x) ~= size(p)
    error("Dimensions of x and p should be the same");
  end
  
  if ~isvector(x) || ~isvector(p)
    error("x and p should be either row or column vectors");
  end
  
  len = length(p);
  x_out = zeros(1, M);

  for i = 1 : M
    u = rand(1, 1);
  
    if (u <= p(1))
      x_out(i) = x(1);
    end
  
    for j = 2 : len
      if (u > p(j-1)) && (u <= p(j-1) + p(j))
        x_out(i) = x(j);
      end
    end
  end
end

%% Problem 1.3, book problem 4.29
% Let X be a random variable taking the following values:
%   0 - Success (probability = 0.5)
%   1 - Failure (probability = 0.25)
%   2 - Don't know (probability = 0.25)

% Do the experiment from 1 to 10000 times and plot the probability of 3
% successes in 5 trials
MAX_NUM_EXP = 5000;
count = zeros(1, MAX_NUM_EXP);
prob = zeros(1, MAX_NUM_EXP);

for total_exp_num = 1 : MAX_NUM_EXP
  for i = 1 : total_exp_num
    % Generate 5 random samples (for simulating 5 trials)
    x = generate_random_samples(5, [0, 1, 2], [0.5, 0.25, 0.25]);
  
    % Count the number of successes and if it's 3
    if (3 == sum(x == 0))
      count(total_exp_num) = count(total_exp_num) + 1;
    end
  end

  prob(total_exp_num) = count(total_exp_num) / total_exp_num;
end

figure;
plot(prob);
hold on;
% Plot a line for the theoretical probability
line((1 : MAX_NUM_EXP), 5/16 * ones(1, MAX_NUM_EXP), "LineWidth", 2);
hold off;
ylim([0 1]);
legend("Simulated probability", "Theoretical probability");
title("Probability of 3 successes in 5 trials");
xlabel("Number of experiments"); ylabel("Probability");

%% Problem 1.9, book problem 11.46
clear;

MAX_NUM_SAMPLES = 1000;
STEP_SIZE = 100;

means = zeros(1, MAX_NUM_SAMPLES / STEP_SIZE);
vars = zeros(1, MAX_NUM_SAMPLES / STEP_SIZE);

for i = STEP_SIZE : STEP_SIZE : MAX_NUM_SAMPLES
  clear x;
  x = raylrnd(1, 1, i);
  means(i / STEP_SIZE) = mean(x);
  vars(i / STEP_SIZE) = var(x);
end

figure;
plot(means);
hold on;
plot(vars);
% Plot a line for the theoretical mean (sqrt(pi/2)) and variance (2 - pi/2)
line((1 : length(means)), sqrt(pi/2) * ones(1, length(means)), "LineWidth", 2);
line((1 : length(vars)), (2 - pi/2) * ones(1, length(vars)), "LineWidth", 2);
hold off;
xticklabels(STEP_SIZE : STEP_SIZE : MAX_NUM_SAMPLES);
ylim([0 2]);
legend( ...
  "Simulated mean", "Simulated variance", "Theoretical mean", ...
  "Theoretical variance");
title("Mean and variance of a Rayleigh distribution with \sigma = 1");
xlabel("Number of experiments"); ylabel("Value");

%% Problem 4
clear;

num_samples = [1e2, 1e4, 1e7];

figure;
sgtitle("Empirical vs Theoretical CDF a standard normal distribution");

cnt = 1;
for i = num_samples
  clear x f val;
  subplot(2, 2, cnt);
  x = normrnd(0, 1, [1, i]);
  [f, val] = ecdf(x);
  plot(val, f);
  title(sprintf("Empirical CDF with 10^{%d} samples", log10(i)));
  xlim([-4, 4]);
  cnt = cnt + 1;
end

% CDF of the theoretical distribution
subplot(2, 2, 4);
x1 = linspace(-4, 4, 1000);
f1 = normcdf(x1);
plot(x1, f1);
title("Theoretical CDF from [-4, 4]");

% Part 5 - estimate P[−1 <= X <= 1] empirically
count = 0;
for i = x
  if (i >= -1) && (i <= 1)
    count = count + 1;
  end
end

fprintf("Empirical P[−1 <= X <= 1] = %.5f\n", count / num_samples(3));

% Part 6 - Numerical integration for the the theoretical P[−1 <= X <= 1]
fun = @(x) (1 / sqrt(2 * pi)) .* exp(-(x.^2) / 2);
fprintf("Theoretical P[−1 <= X <= 1] = %.5f\n", integral(fun, -1, 1));
