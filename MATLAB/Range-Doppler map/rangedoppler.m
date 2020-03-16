clear;
clc;

load RangeDopplerExampleData;


response = phased.RangeDopplerResponse('DopplerFFTLengthSource','Property', ...
   'DopplerFFTLength',RangeDopplerEx_MF_NFFTDOP, ...
   'SampleRate',RangeDopplerEx_MF_Fs,'DopplerOutput','Speed', ...
   'OperatingFrequency',RangeDopplerEx_MF_Fc);

[resp,rng_grid,dop_grid] = response(RangeDopplerEx_MF_X, ...
    RangeDopplerEx_MF_Coeff);

imagesc(dop_grid,rng_grid,mag2db(abs(resp)));
xlabel('Speed (m/s)');
ylabel('Range (m)');
title('Range-Doppler Map');