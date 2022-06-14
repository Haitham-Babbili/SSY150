function [decoded,cnumerr]=RSdecoder(codes)
m=8;                                   %Bits per symbol
n=2^m-1;                               %codeword length
k=127;                                 %Message length
%dec_msg=gf(codes,m);                   %represent encoded msg using glaois array
[decoded,cnumerr]=rsdec(codes,n,k);  %RS decoding
decoded=decoded.x;