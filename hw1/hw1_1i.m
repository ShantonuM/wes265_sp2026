%% Problem 1.9, book problem 11.46
close all; clc; clear;

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
line( ...
  (1 : length(means)), sqrt(pi/2) * ones(1, length(means)), ...
  "LineWidth", 2);
line( ...
  (1 : length(vars)), (2 - pi/2) * ones(1, length(vars)), ...
  "LineWidth", 2);
hold off;
xticklabels(STEP_SIZE : STEP_SIZE : MAX_NUM_SAMPLES);
ylim([0 2]);
legend( ...
  "Simulated mean", "Simulated variance", ...
  "Theoretical mean", "Theoretical variance");
title( ...
  "Mean and variance of a Rayleigh distribution with \sigma = 1");
xlabel("Number of experiments"); ylabel("Value");