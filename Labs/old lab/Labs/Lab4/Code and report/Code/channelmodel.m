function [code_noisy]=channelmodel(codes)
m=8;                                                       %Bits per symbol
n=2^m-1;                                                   %codeword length
k=127;                                                     %Message length
% t=floor(n-k/2);                                          %Number of correctable errors
t=100;
channel=2;                                                 %for selecting channel 1 or 2
nw=260;                                                    %number of codewords
switch channel
    case 1
     noise=(1+randint(nw,n,n)).*randerr(nw,n,t);           %'t'errors per row,for'codes' codewords
     cnoisy=codes+noise;                                   %add noise to the code
     code_noisy = cnoisy;
    case 2
     PL=floor(0.02*nw);                                    %packet loss(10% of total packets)   
     PL_in=round(nw*rand(1,PL));                           %randomly generated indices   
     for i=1:PL
     e_packet = zeros(1, n);                               % generate a codeword with zero value, n is codeword size
     errorpacket= gf(e_packet,m);                          % generate an error packet in Matlab class gf
     codes(PL_in(i), :) = errorpacket;                     % replace the ith codeword by a packet with zero values
     end
     code_noisy=codes;
end