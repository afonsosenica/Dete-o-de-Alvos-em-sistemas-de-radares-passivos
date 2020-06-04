clc
close all
clear all

% Read and info IQ file
info = audioinfo('101_7.wav')
[y,fs] = audioread('101_7.wav');

% Put in 1 column
y = y(:,1);
x = y(1:441);

% Set t and N
N = length(y);
t = (0:N-1)/fs;

% Plot the signal
figure
subplot(2,1,1)   
plot(t,y)
grid on
set(gca, 'FontName','Time New Roman', 'FontSize', 12)
xlabel('Time (s)')
ylabel('Ampl')
title('Signal in time domain')



Rmax = 30e3;
c = 3e8;
prf = c/(2*Rmax);
bw = 200000;
fs = 44100;
fc = 101.9e6;



deltav_lfm = dop2speed(20e3,c/fc);
[afmag_lfm,delay_lfm,doppler_lfm] = ambgfun(x,44100,100);

subplot(2,1,2)  
surf(delay_lfm*1e6,doppler_lfm/1e3,afmag_lfm,'LineStyle','none'); 
axis tight; grid on; view([140,35]); colorbar;
xlabel('Delay \tau (us)');ylabel('Doppler f_d (kHz)');
title('Ambiguity Function');

%spectrogram(y, 1024, 512,1024, fs)
%title('Ambiguity Function')