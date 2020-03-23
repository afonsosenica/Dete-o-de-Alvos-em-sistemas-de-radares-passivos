clc;
clear;
close all;


f = input('Enter the frequency of signal = ');
F = input('Enter the sampling frequency = ');
A = input('Enter max amplitude of signal = ');
qbits = input('Enter the number of quantization bits = ');
fc = input('Enter the lowpass filter cutoff frequency = ');
L = 2^qbits;
I = 2*A/(L-1); 
% Settings for Spectrum Scope
span = 8*F;
span1 = 8*F;
NFFT = 256;
% To run simulink model
t = 1/f;
sim_time = 10*t; 
sim('sampling.slx');