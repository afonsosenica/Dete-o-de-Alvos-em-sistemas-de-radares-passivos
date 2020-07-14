t = bufferRx(5100001:5102000);
x = transpose(t);

t0 = bufferRx(10200001:10202000);
x0 = transpose(t0);

t00 = bufferRx1(15300001:15302000);
x00 = transpose(t00);

t000 = bufferRx(20400001:20402000);
x000 = transpose(t000);



t1 = bufferRx1(5100001:5102000);
x1 = transpose(t1);

t11 = bufferRx1(10200001:10202000);
x11 = transpose(t11);

t111 = bufferRx1(15300001:15302000);
x111 = transpose(t111);

t1111 = bufferRx1(20400001:20402000);
x1111 = transpose(t1111);


[afmag3,delay3,doppler3] = ambgfun(x,x1,Fs,[250000 250000]);
afmag3 = afmag3*1.5;
afmag3(afmag3>1 )= 1;

[afmag4,delay4,doppler4] = ambgfun(x0,x11,Fs,[250000 250000]);
afmag4 = afmag4*1.5;
afmag4(afmag4>1 )= 1;

[afmag5,delay5,doppler5] = ambgfun(x00,x111,Fs,[250000 250000]);
afmag5 = afmag5*1.5;
afmag5(afmag5>1 )= 1;

[afmag6,delay6,doppler6] = ambgfun(x000,x1111,Fs,[250000 250000]);
afmag6 = afmag6*1.5;
afmag6(afmag6>1 )= 1;




subplot(3,2,1)
surf(delay3,doppler3,afmag3,'LineStyle','none'); 
shading interp;
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation 0.3s');


subplot(3,2,2)
surf(delay4,doppler4,afmag4,'LineStyle','none'); 
shading interp;
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation 0.6s');


subplot(3,2,3)
surf(delay5,doppler5,afmag5,'LineStyle','none'); 
shading interp;
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation 0.9s');


subplot(3,2,4)
surf(delay6,doppler6,afmag6,'LineStyle','none'); 
shading interp;
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view([140,35]); 
colorbar;
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation 1.2s');


subplot(3,2,5)
colormap(1-gray);
imagesc(delay5,doppler5,10*log10(afmag5)); 
axis([-0.3e-6 0.3e-6 -1500 1500]); 
zlim([0 1]);
grid on; 
view(2); 
xlabel('Delay \tau (s)');
ylabel('Doppler f_d (Hz)');
title('Cross-correlation');