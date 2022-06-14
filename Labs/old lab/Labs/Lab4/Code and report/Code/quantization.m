function [Index,quantized,codebook]=quantization(signal)
Max=max(signal);
Min=min(signal);
m=8;                            %bits per sample
L=2^m;                          %No of quantization levels
Delta=(Max-Min)/(L-1);          %Step size
codebook=Min:Delta:Max;         %Reconstruction levels
partition=(codebook-Delta/2);   %Decision thresholds 
partition=partition(2:end);     %Decision threshold vector
%m = 256;                                                % Number of quantization levels
% partition = linspace(min(signal),max(signal),L);        % Decision boundaries
% rmin = partition(1,1) +(partition(1,1)-partition(1,2))/2;
% rmax = partition(1,256) +(partition(1,256)-partition(1,255))/2;
% codebook = linspace(rmin,rmax,L+1);                  % Reconstruction Levels
[Index,quantized]=quantiz(signal,partition,codebook);    %scalar quantization
% plot(codebook,ones(1,256),'r+');
% hold on
% plot(partition,ones(1,255),'b+');