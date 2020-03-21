 % Import signal from GNU radio
 signalo=read_complex_binary('signal.dat');
 
 
   % ----------------------- FUNCTIONS ----------------------- 
 function X = Dft(x)
% If the input x is an array:
if isvector(x) == 1
X = fftshift(fft(x))/length(x);
else
% x the input x is a matrix:
X = fftshift(fft(x),1)/ size (x,1);
end
endfunction 


 function x = IDft(X)
% If the input x is an array:
if isvector(X) == 1
x = ifft(ifftshift(X))*length(X);
else
% x the input x is a matrix:
x = ifft(ifftshift(X),1)*size (x,1);
end
endfunction

  
 
 function correlation = correlate(array1, array2)
    correlation=conv(fliplr(conj(array1)),array2);
 endfunction  
 
 
 % ----------------------- DATA ----------------------- 
 % Transpose of the collected signal, because gnu radio exports a column vector
 signal=transpose(signalo);
 
 % Value of the length of the signal - lgt
 lgt=length(signal);
 
 % Create zero matrix with 2*lgt-1 because the convolution of A and B has a 2*lgt-1 lenght
 A=zeros(1,2*lgt-1);
 
 % ---------------------------------------------------- 

 fftsignal=Dft(signal);
 ifftsignal=IDft(fftsignal);
 
 
  t=0:lgt-1;
 %signal=ones(1,length(t));
 
 doppler=-5:0.1:5;
 
 %Initiate
 
 correlations=zeros(length(doppler),2*length(signal)-1);

 nrow=0;
 for angularDoppler=2*pi*doppler
    nrow=nrow+1;
    correlation(nrow,:)=correlate(signal,exp(i*angularDoppler*t).*signal);
 endfor
 
 
 plot(abs(correlation))
 
 