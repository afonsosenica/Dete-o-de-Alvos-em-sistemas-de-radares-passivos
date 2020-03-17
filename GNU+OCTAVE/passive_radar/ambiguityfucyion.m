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
 
 
  % ---------------------------------------------- 
  
  function correlation=correlate(array1, array2)
    correlation=conv(fliplr(conj(array1)),array2);
  end 
  
  
 t=0:0.1:4;
 signal=ones(1,length(t));
 
 dopplerFrequencies=-5:0.1:5;
 
 %Initiate
 
correlations=zeros(length(dopplerFrequencies),2*length(signal)-1);

rowNumber=0;
for angularDoppler=2*pi*dopplerFrequencies
    rowNumber=rowNumber+1;
    correlation(rowNumber,:)=...
      correlate(signal,exp(i*angularDoppler*t).*signal);
endfor

plot(abs(correlation))