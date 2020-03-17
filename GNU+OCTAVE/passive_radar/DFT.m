function X = Dft(x)
% If the input x is an array:
if isvector(x) == 1
X = fftshift(fft(x))/length(x);
else
% x the input x is a matrix:
X = fftshift(fft(x),1)/ size (x,1);
end
endfunction