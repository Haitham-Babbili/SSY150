close all;
clc;
clear all;
%% Task 1
% step 1.1.1
orgimg=imread('lena.bmp');%reading image
%figure;imshow(orgimg);title('Original Image')%displaying image
% step 1.1.2
cnvimg=mat2gray(orgimg);%converting image format
figure;imshow(cnvimg);title('Converted Image')%converted image
[R C]=size(cnvimg);
imdimg=dct(cnvimg.');%applying dct on rows
figure;imshow(imdimg);title('DCT on rows');
% step 1.1.3
fnlimg=dct(imdimg.');%applying dct on coloumns
figure;imshow(fnlimg);title('DCT on rows and columns');
% step 1.2.1
invimdimg=idct(fnlimg);%applying idct on columns
figure;imshow(invimdimg);title('IDCT on Columns');
diff=invimdimg-imdimg;%yes they have small values
% step 1.2.2
invfnlimg=idct(invimdimg.').';%applying idct on rows
figure;imshow(invfnlimg);title('IDCT on rows and columns');
% step 1.2.3
error=abs(cnvimg-invfnlimg);%difference bw original and final image
MSE = sum(sum(error.^2))/(C*R);%MSE(3.4511e-032)
% step 1.3
dctcoeff=reshape(fnlimg,1,R*C);
[srtdctcoeff Indx]=sort(abs(dctcoeff));%sorting dct coefficients in ascending order
Th=srtdctcoeff(floor(R*C*0.9));%setting the threshold(Threshold value=0.1047)
cmpfnlimg=fnlimg;
cmpfnlimg( abs(dctcoeff)<=Th ) = 0;%compressing the image by removing small value dct coefficients
% step 1.4
invcmpimdimg=idct(cmpfnlimg);%applying idct on columns
%figure;imshow(invcmpimdimg);title('IDCT on Columns');
%diff=invcmpimdimg-imdimg;%yes they have small values
% step 1.4.2
invcmpfnlimg=idct(invcmpimdimg.').';%applying dct on rows
figure;imshow(invcmpfnlimg);title('Compressed image');
% step 1.4.3
errorimage=abs(cnvimg-invcmpfnlimg);%difference bw original and compressed image
figure;imshow(30*errorimage);title('30 times enlarged error image');
MSE1 = sum(sum(abs(errorimage).^2))/(C*R);%computing psnr(MSE1=0.0012)
PSNR = 10*log10(1/MSE1);   %29.3336db
%% Task 2
% step 2.1.1
orgimg=imread('lena.bmp');%reading image
%figure;imshow(orgimg);title('Original Image')%displaying image
% step 2.1.2
cnvimg=mat2gray(orgimg);%converting image format
figure;imshow(cnvimg);title('Converted Image')%converted image
[R C]=size(cnvimg);
% step2.2
Blocksize=8;
RB=R/Blocksize;%TO make 8*8 blocks
CB=C/Blocksize;
for i=1:RB
    for j=1:CB
       temp=cnvimg((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize);
       tempDCT = dct2(temp);%applying 2d dct to all 8*8 blocks and saving it in bbi
       bbi((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize) = tempDCT;
    end
end
figure;imshow (bbi);title('2D block based transformed DCT image');
% step2.3
dctcoeff1=reshape(bbi,1,R*C);
[srtdctcoeff1 Indx]=sort(abs(dctcoeff1));%sorting dct coefficients in ascending order
Th1=srtdctcoeff1(floor(R*C*0.9));%setting the threshold(Threshold value=0.0946)
cmpbbi=bbi;
cmpbbi( abs(dctcoeff1)<=Th1 ) = 0;
%step2.4
for i=1:RB
    for j=1:CB
       temp=cmpbbi((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize);
       tempIDCT = idct2(temp);%applying inverse 2d dct to all 8*8 blocks and saving it in invbbi
       invbbi((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize) = tempIDCT;
    end
end
figure;imshow (invbbi);title('2D inverse block transformed DCT image');%Block based compressed image
%step2.5
errorimage=abs(cnvimg-invbbi);%difference bw original and final image
figure;imshow(30*errorimage);title('30 times enlarged error image');
MSE2 = sum(sum(abs(errorimage).^2))/(C*R);%computing psnr(MSE2=5.6803e-004)
PSNR1 = 10*log10(1/MSE2);   %32.4563db
%% % Task 3
close all;
clc;
clear all;
load ('waveletcompressedimage.mat')
orgimg=imread('lena.bmp');%reading image
%figure;imshow(orgimg);title('Original Image')%displaying image
cnvimg=mat2gray(orgimg);%converting image format
figure;imshow(cnvimg);title('Converted Image')%displaying image
[R C]=size(cnvimg);
wci = mat2gray(X);%changing format of wavelet compressed image
figure;imshow(wci);title('Wavelet compressed Image')%displaying image
errorimage=abs(cnvimg-wci);%error
%figure;imshow(30*errorimage);title('30 times enlarged error image')
MSE2=sum(sum(abs(errorimage).^2))/(R*C);%calculating PSNR(MSE2=8.6377e-004)
PSNR = 10*log10(1/MSE2);    %30.6360db      
figure;
load wci207715.mat
wci95 = mat2gray(X);
imshow(wci95);title('wavelet compressed image with CR=20% and TH=.7715')
figure;
load wci80898.mat
wci9550 = mat2gray(X);
imshow(wci9550);title('wavelet compressed image with CR=80% and TH=8.98')



