clear all
clc

FFTsize = 1024;           % Number of FFT points
numGuards = 212;         % Guard bands on both sides
K = 4;                   % Overlapping symbols, one of 2, 3, or 4
numSymbols = 100;        % Simulation length in symbols
bitsPerSubCarrier = 2;   % 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM
snrdB = 12;              % SNR in dB
L = FFTsize-2*numGuards;  % Number of complex symbols per OFDM symbol

sumOFDMSpec = zeros(FFTsize*2, 1);


for symIdx = 1:numSymbols

    inpData2 = randi([0 1], bitsPerSubCarrier*L, 1);
    modData = qammod(inpData2, 2^bitsPerSubCarrier, ...
        'InputType', 'Bit', 'UnitAveragePower', true);

    symOFDM = [zeros(numGuards,1); modData; zeros(numGuards,1)];
    ifftOut = sqrt(FFTsize).*ifft(ifftshift(symOFDM));

    [specOFDM,fOFDM] = periodogram(ifftOut, rectwin(length(ifftOut)), ...
        FFTsize*2, 1, 'centered');
    sumOFDMSpec = sumOFDMSpec + specOFDM;
end

% Plot power spectral density (PSD) over all subcarriers
sumOFDMSpec = sumOFDMSpec/mean(sumOFDMSpec(1+2*numGuards:end-2*numGuards));
figure;
plot(fOFDM,10*log10(sumOFDMSpec));
grid on
axis([-0.5 0.5 -180 10]);
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['OFDM, FFT size = ' num2str(FFTsize)])
set(gcf, 'Position', figposition([46 50 30 30]));