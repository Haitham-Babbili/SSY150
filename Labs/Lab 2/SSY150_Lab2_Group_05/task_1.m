%###### Task 1 ######%

clc
close all;
clear all;

% Read lena imag
im=imread('lena.bmp');
i_form=mat2gray(im);

% % Read the video 
% [film,num_frames]=read_video('Trees1.avi');
% 
% % get frame into image
% i_fram=frame2im(film(14));
% 
% % convert from colorscal to grayscale
% i_gray=rgb2gray(i_fram);
% 
% 
% %imwrite(i_gray,'1.bmp');
% 
% % convert image format 
% i_form=mat2gray(i_gray);

%% 1.2
% convert to DCT
Img=dct2(i_form);

%% 1.3
% Compression ratio
com_ra=0.98;

% Compress DCT coecients by setting zeros to small value coecients.  
Img_com=compres_dct(Img,com_ra);

%% 1.4

% get inverse of DCT
i_inv=idct2(Img_com);

% get the error by count the diffrence between the original and the invers
e=abs(i_form-i_inv);

% count PSNR
PSNR=psnr(i_inv,i_form);

% count MSSIM
MSSIM=ssim(i_inv,i_form);


figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(2,2,1)
imshow(i_form) 
title('Original Image','FontSize',16,'FontWeight','bold')

subplot(2,2,2) 
imshow(Img_com)
title('DCT Image Comprission','FontSize',16,'FontWeight','bold')

subplot(2,2,3)
imshow(i_inv) 
title('Compressed Image','FontSize',16,'FontWeight','bold') 

subplot(2,2,4)
imshow(e*30)
title('Error','FontSize',16,'FontWeight','bold')
