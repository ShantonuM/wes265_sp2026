%% Problem 1.6, book problem 5.31
close all; clc; clear;

fprintf( ...
  'P(More than 100 calls in a minute) = %.3e\n', 1 - poisscdf(100, 60));
