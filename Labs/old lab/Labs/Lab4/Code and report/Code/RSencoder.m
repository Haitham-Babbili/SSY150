function [codes,msgwords]=RSencoder(packet)
m=8;                                   %Bits per symbol
n=2^m-1;                               %codeword length
k=127;                                 %Message length
msgwords=gf(packet,m);                 %represent packets using glaois array
codes=rsenc(msgwords,n,k);             %RS encoding
msgwords=msgwords.x;
%codewords=codes.x;                    %Extract rows of codewords from GF array