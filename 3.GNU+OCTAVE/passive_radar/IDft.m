function x = IDft(X)
% If the input x is an array:
if isvector(X) == 1
x = ifft(ifftshift(X))*length(X);
else
% x the input x is a matrix:
x = ifft(ifftshift(X),1)*size (x,1);
end
endfunction