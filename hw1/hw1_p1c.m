%% Problem 1.3, book problem 4.29
close all; clc; clear;

%------------------------------------------------------------
% Helper functions
%------------------------------------------------------------

%------------------------------------------------------------
% generate_random_samples
%
% Generates M random samples (simulating M trials) from the
% possible input values with assigned probabilities.
% 
% of the transfer function.
% Parameters:
%   M - Number of trials (number of output samples)
%   x - Vector of input values that the random variable can
%       take
%   p - Vector with probability of each of the input value
%------------------------------------------------------------

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

% Let X be a random variable taking the following values:
%   0 - Success (probability = 0.5)
%   1 - Failure (probability = 0.25)
%   2 - Don't know (probability = 0.25)

% Do the experiment from 1 to 10000 times and plot the
% probability of 3 successes in 5 trials
MAX_NUM_EXP = 5000;
count = zeros(1, MAX_NUM_EXP);
prob = zeros(1, MAX_NUM_EXP);

for total_exp_num = 1 : MAX_NUM_EXP
  for i = 1 : total_exp_num
    % Generate 5 random samples (for simulating 5 trials)
    x = generate_random_samples(5, [0 1 2], [0.5 0.25 0.25]);
  
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
line((1 : MAX_NUM_EXP), 5/16 * ones(1, MAX_NUM_EXP), 'LineWidth', 2);
hold off;
ylim([0 1]);
legend('Simulated probability', 'Theoretical probability');
title('Probability of 3 successes in 5 trials');
xlabel('Number of experiments'); ylabel('Probability');
yticks(0 : 0.1 : 1);
grid on; grid minor; axis('padded');