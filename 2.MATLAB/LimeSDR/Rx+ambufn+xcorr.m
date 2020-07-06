% Author of the LimeSDR MATLAB compatibility program:
%    Damir Rakhimov, CRL, TU Ilmenau, Dec 2019

% Author of the current program, based on the simple RX by Damir Rakhimov:
%    Afonso Sénica, Escola Naval, June 2020



clc
clear all

addpath('../_library') % add path with LimeSuite library

% Initialize parameters
TotalTime   = 1;       % Time of observation, s
Fc          = 602e6;   % Carrier Frequency, Hz
Fs          = 17e6;    % Frequency of sampling frequency, Hz
Ts          = 2;      % Signal duration, s
Fsig        = 602e6;    % Frequency of desired signal, Hz
Asig        = 1;        % Amplitude of signal, V
BW          = 8e6;      % Bandwidth of the signal, Hz (5-40MHz and 50-130Mhz)
Gain        = 24;       % Receiver Gain, dB

% Open LimeSDR
dev = limeSDR(); % Open device

% Setup device parameters. These may be changed while the device is actively streaming.
dev.rx0.frequency   = Fc;
dev.rx0.samplerate  = Fs;
dev.rx0.bandwidth   = BW;
dev.rx0.gain        = Gain;
dev.rx0.antenna     = 2;     % LNA_L

dev.rx1.frequency   = Fc;
dev.rx1.samplerate  = Fs;
dev.rx1.bandwidth   = BW;
dev.rx1.gain        = Gain;
dev.rx1.antenna     = 2;     % LNA_L

% Read parameters from the devices
Fs_dev      = dev.rx0.samplerate;  % in SPS
Fc_dev      = dev.rx0.frequency;
BW_dev      = dev.rx0.bandwidth;
Ant_dev     = dev.rx0.antenna;
Gain_dev    = dev.rx0.gain;
ChipTemp    = dev.chiptemp;
fprintf('Rx Device sampling frequency: %3.1fHz, Initial sampling frequency: %3.1fHz\n', Fs_dev, Fs);
fprintf('Rx Device carrier frequency: %3.1fHz, Initial carrier frequency: %3.1fHz\n', Fc_dev, Fc);
fprintf('Rx Device bandwidth: %3.1fHz, Initial bandwith: %3.1fHz\n', BW_dev, BW);
fprintf('Rx Device antenna: %d \n', Ant_dev);
fprintf('Rx Device gain: %3.1fdB, Initial gain: %3.1fdB\n', Gain_dev, Gain);
fprintf('Rx Device temperature: %3.1fC\n', ChipTemp);

Fs_dev1      = dev.rx1.samplerate;  % in SPS
Fc_dev1      = dev.rx1.frequency;
BW_dev1      = dev.rx1.bandwidth;
Ant_dev1     = dev.rx1.antenna;
Gain_dev1    = dev.rx1.gain;

% Create empty array for the received signal
bufferRx    = complex(zeros(TotalTime*Fs,1));

bufferRx1    = complex(zeros(TotalTime*Fs,1));

% Enable stream parameters. 
dev.rx0.enable;

dev.rx1.enable;

% Calibrate RX channel
dev.rx0.calibrate;

dev.rx1.calibrate;

% Start the module
dev.start();
fprintf('Start of LimeSDR\n');

% Receive samples on RX0 channel
indRx = 1;  % index of the last received sample
for idxLoop = 1:round(TotalTime/Ts)
    tic;
    [samples, ~, samplesLength]             = dev.receive(Fs*Ts,0);
    bufferRx(indRx:indRx+samplesLength-1)   = samples;
    indRx           = indRx + samplesLength;
    status          = dev.rx0.status;
    fprintf('Received samples: %d\n', samplesLength);
    fprintf('Fifo size: %d\n', status.fifoFilledCount);
end
pause(1)

indRx1 = 1;  % index of the last received sample
for idxLoop1 = 1:round(TotalTime/Ts)
    tic;
    [samples1, ~, samplesLength1]             = dev.receive(Fs*Ts,0);
    bufferRx1(indRx1:indRx1+samplesLength1-1)   = samples1;
    indRx1           = indRx1 + samplesLength1;
    status1          = dev.rx1.status;
    fprintf('Received samples: %d\n', samplesLength1);
    fprintf('Fifo size: %d\n', status1.fifoFilledCount);
end
pause(1)

% Cleanup and shutdown by stopping the RX stream and having MATLAB delete the handle object.
dev.stop();
clear dev;
fprintf('Stop of LimeSDR\n');


% Select a few samples to get the process quicker
t = bufferRx(1:10000);
x = transpose(t);


t1 = bufferRx1(1:10000);
x1 = transpose(t1);

% Select plot gain *1
% Sref ambiguity function
[afmag,delay,doppler] = ambgfun(x,Fs,250000);
afmag = afmag*1;
afmag(afmag>1 )= 1;

% Sr ambiguity function
[afmag2,delay2,doppler2] = ambgfun(x1,Fs,250000);
afmag2 = afmag2*1;
afmag2(afmag2>1 )= 1;

% Correlation
[afmag3,delay3,doppler3] = ambgfun(x,x1,Fs,[250000 250000]);
afmag3 = afmag3*1.5;
afmag3(afmag3>1 )= 1;


% Plot spectrograms of the recieved signals
tic
figure(1)
subplot(3,2,1);
spectrogram(bufferRx,2^12,2^10,2^12,'centered','yaxis')

subplot(3,2,2);
spectrogram(bufferRx1,2^12,2^10,2^12,'centered','yaxis')

fprintf('Time for visualisation: %g\n', toc);


% Plot the ambiguity functions of Sref and Sr
subplot(3,2,3)
surf(delay,doppler,afmag,'LineStyle','none'); 
shading interp;
axis([-0.5e-5 0.5e-5 -10000 10000]); 
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Ambiguity Function Sref');


subplot(3,2,4)   
surf(delay2,doppler2,afmag2,'LineStyle','none'); 
shading interp;
axis([-0.5e-5 0.5e-5 -10000 10000]); 
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (us)');
ylabel('Doppler f_d (kHz)');
title('Ambiguity Function Sr');


% Plot the correlation of Sref and Sr

subplot(3,2,5)
surf(delay3,doppler3,afmag3,'LineStyle','none'); 
shading interp;
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation');