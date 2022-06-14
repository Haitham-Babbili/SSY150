clc
close all
clear all



% Read the image
% i=imread('lena.bmp'); % lena image
i=imread('1.bmp'); % image from first frame in .avi file

I=mat2gray(i);
% convert to DCT
I_dct=dct2(I);

% load compressed image  
% load('I_3_comp_lena.mat'); % load compressed image from first frame in .avi file
load('I_3_comp.mat'); % load compressed image from first frame in .avi file
I_3=mat2gray(X);

e= abs(I-I_3);

% count PSNR
PSNR=psnr(I_3,I);

% count MSSIM
MSSIM=ssim(I_3,I);

figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(2,2,1)
imshow(I) 
title('Original Image','FontSize',16,'FontWeight','bold')

subplot(2,2,2) 
imshow(I_dct)
title('DCT Image Comprission','FontSize',16,'FontWeight','bold')

subplot(2,2,3)
imshow(I_3) 
title('I_3 Compressed image','FontSize',16,'FontWeight','bold') 

subplot(2,2,4)
imshow(e*30)
title('Error','FontSize',16,'FontWeight','bold')