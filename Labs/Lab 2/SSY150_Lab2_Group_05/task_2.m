%###### Task 2 ######%

clc
clear all
close all

% Read lena imag
im=imread('lena.bmp');
[x,y]=size(im);
width = x;
height = y;
img=mat2gray(im);

% video = VideoReader('Trees1.avi');
% width = video.width - 1;
% height = video.height - 1;
% 
% move = struct('frames',zeros(height,width));
% 
% frame_num = round(video.Duration * video.FrameRate);
% for i = 1:frame_num
% move(i).frames = readFrame(video);
% end
% 
% img = mat2gray(move(1).frames(1:height,1:width,1));

rect_block = 8;
for i = 1:width/rect_block
    for j = 1:height/rect_block
        Imag((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block) = dct2(img((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block));
    end
end


com_ra = 0.98;
resize = reshape(Imag,1,width*height);
permenent_order = sort(abs(resize),'ascend');
th = (permenent_order(round(com_ra*width*height)));

vec = abs(Imag) > th;

img_comp = Imag.*vec;


for i = 1:width/rect_block
    for j = 1:height/rect_block
        Img_comp((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block) = idct2(img_comp((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block));
        
    end
end

% caunt the error
e = abs(img-Img_comp);

% count PSNR
PSNR = psnr(Img_comp,img);

% count MSSIM
MSSIM = ssim(Img_comp,img); 

figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(2,2,1)
imshow(img)
title('Original image','FontSize',16,'FontWeight','bold')

subplot(2,2,2)
imshow(Imag)
title('DCT Image Comprission','FontSize',16,'FontWeight','bold')

subplot(2,2,3)
imshow(Img_comp)
title('Compressed Image','FontSize',16,'FontWeight','bold')

subplot(2,2,4)
imshow(30.*e)
title('Error','FontSize',16,'FontWeight','bold')





