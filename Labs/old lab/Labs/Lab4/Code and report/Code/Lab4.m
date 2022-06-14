Close all;
clear all;
clc;
%% Block 1
%step 4.1
orgimg=imread('lena.bmp');                       %reading image
orgimg=mat2gray(orgimg);                         %converting image format to intensity image
figure;
imshow(orgimg);
title('Original Image')    %Displaying image
%step 4.2
Rcompression=0.5;                                %Setting the compression ratio
%step 4.3(Block1)
%step 4.3.1
[Z_c CImage Z]=DCT(orgimg);                      %function call
%% Task1
%Step 1.2(Block 2)
[Index,quantized,codebook]=quantization(Z_c);  %function call
%% Task2
%step 2.1(Block3)
packet=packetizer(Index);       %function call 
%% Task3
%step 3.1(Block4)
packet=packet.';                        %Each row representing 1 source packet of size 127symbols
[codes,msgwords]=RSencoder(packet);     %function call
%% Task7
% %step7.1(Block 5)
Nrows = 260;                                             % Number of interleved rows
Ncols = 255;                                             % Number of interleaved columns
data = codes;
intrlvd = reshape(data,Ncols,Nrows).';
%% Task5
% %block 7
[code_noisy]=channelmodel(intrlvd);             %function call
%step7.2(Block 9)
deintrlvd = reshape(code_noisy.',Nrows,Ncols);
%deintrlvr=matdeintrlv(intrlvd,15,17);            %matrix deinterleaving
 
%step 3.2(Block9)
[decoded,cnumerr]=RSdecoder(deintrlvd);     %function call
%isequal(decoded,msgwords)              %To verify encoded and decoded msg
%step 2.2(Block10)
depacket=depacketizer(decoded);           %function call
%step 1.3(Block 11)
quantizedv=block11(depacket,codebook);      %function call
%step 4.4(block12)
%step4.4.1
invimg=IDCT(quantizedv,orgimg);                       %function call
figure;imshow(invimg);title('Reconstructed image')  








