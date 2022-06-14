function quantizedv=block11(Index,codebook)

quantizedv=codebook(Index+1);                                   %Quantized Levels(quantization values)

%figure;plot(quantizedv),title('QSW at output of block11');        %plot of quantized sine wave