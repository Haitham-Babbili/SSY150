%###### Task 4 & 5 & 6 & 7 & 8 ######%

clc
close all
clear all

%###### Task 5 ######

video = VideoReader('Trees1.avi');
width = video.width - 1;
height = video.height - 1;

mov = struct('frames',zeros(height,width));

fram_num = round(video.Duration * video.FrameRate);
for i = 1:fram_num
mov(i).frames = readFrame(video);
end

img_2 = mat2gray(mov(14).frames(1:end-1,1:end-1,1));

img_2 = compres(img_2,width,height);


img_1 = mat2gray(mov(15).frames(1:end-1,1:end-1,1));


th = 64/255;

i_diff = img_1-img_2;

vec = abs(i_diff > th);
i_diff = i_diff .* vec;


% create empty blocks
comp = zeros(8);

% rectangular blocks (size 8x8)
rect_block = 8;
for i = 1:width/rect_block
    for j = 1:height/rect_block
        i_motion((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block) = ~isequal(comp, i_diff((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block));
        
    end
end


%% ###### Task 6 ######
i_mot = zeros(height,width);

mov = zeros(height/8,width/8,2);
rect_block = 8;
input_block=img_1((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block);
% y_begin=(j-1)*8+1;
% x_begn=(i-1)*8+1;
for i = 1:width/rect_block
    for j = 1:height/rect_block
        if  ~isequal(i_motion((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block),comp)
            mov(j,i,:) = motion_Vec(img_1((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block),(j-1)*8+1,(i-1)*8+1,width,height,img_2);
        end
        
    end
end


figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(2,2,1)
imshow(img_1)
title('Old frame','FontSize',16,'FontWeight','bold')

subplot(2,2,2)
imshow(img_2)
title('New frame','FontSize',16,'FontWeight','bold')

subplot(2,2,3)
imshow(i_diff)
title('Difference','FontSize',16,'FontWeight','bold')

subplot(2,2,4)
imshow(i_motion)
title('Motion blocks','FontSize',16,'FontWeight','bold')

%% ###### Task 7 ######


I4 = zeros(height,width);
I5 = img_2;

for i = 1:width/rect_block
    for j = 1:height/rect_block
        if ~isequal(i_motion((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1:i*rect_block),comp)
            dy = mov(j,i,2);
            dx = mov(j,i,1);

            I4((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1 :i*rect_block) = img_2((j-1)*rect_block+1 + dy :j*rect_block + dy ,(i-1)*rect_block+1 + dx :i*rect_block + dx);
            I5((j-1)*rect_block+1:j*rect_block,(i-1)*rect_block+1 :i*rect_block) = img_2((j-1)*rect_block+1 + dy :j*rect_block + dy ,(i-1)*rect_block+1 + dx :i*rect_block + dx);
            
        end
    end
end



%% ###### Task 8 ######

e=abs(img_1-I5);

PSNR = psnr(I5,img_1);
MSSIM = ssim(I5,img_1);

figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(2,2,1)
imshow(img_1)
title('Orignial frame','FontSize',16,'FontWeight','bold')

subplot(2,2,2)
imshow(I4)
title('Inter frame compensation','FontSize',16,'FontWeight','bold')

subplot(2,2,3)
imshow(I5)
title('Inter and Intra compensation','FontSize',16,'FontWeight','bold')

error = abs(img_1-I5);
error_mag = 30.*error;

subplot(2,2,4)
imshow(error_mag)
title('Error','FontSize',16,'FontWeight','bold')



