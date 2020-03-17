 clc
 clear all
 close all
 
 % Import signal from GNU radio
 signalo=read_complex_binary('signal.dat');
 magnitude=read_complex_binary('mag.dat');
 
 % ----------------------- DATA ----------------------- 
 % Transpose of the collected signal, because gnu radio exports a column vector
 signal=transpose(signalo);
 
 % Value of the length of the signal - lgt
 lgt=length(signal);
 
 % i samples (from gnu radio, i=samp_rate=1024)
 i=1024;
 
 % k is the time
 k=1024;
 % ---------------------------------------------- 
 
 % Doppler row vector from 0 to 1 with lgt samples
 doppler=linspace(-8,8,101);
 
 % Delay
 delay=linspace(0,8,101);
 

 
[xx, yy] = meshgrid (delay, doppler);
r = sqrt (xx .^ 2 + yy .^ 2) + eps;
tz = sin (r) ./ r;
mesh (delay, doppler, tz);
xlabel ("Delay");
ylabel ("Doppler");
zlabel ("Magnitude");
title ("Ambiguity FUnction");