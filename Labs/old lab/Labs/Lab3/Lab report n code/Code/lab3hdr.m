clear all;
close all;
clc;

%% LAB3 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This LAB is to learn about the basics of the Video Compression using  %
% Block-Matching Motion Compensation, For simplicity the process of    %
% encoding and decoding the prediction errors from block matching will %
% be neglected.                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Task1
mov = aviread('Trees1.avi');    % read the avi file
%movie(mov);                    % display the movie
length(mov);                    % number of frames

% extracting and saving the 75-79th frames 

I1=frame2im(mov(75));     % extracting
I1=rgb2gray(I1);          % convert to gray scale
imwrite(I1,'frame1.bmp'); % saving into hard disc
I2=frame2im(mov(76)); 
I2=rgb2gray(I2); 
imwrite(I2,'frame2.bmp'); % saving into hard disc
I3=frame2im(mov(77)); 
I3=rgb2gray(I3); 
imwrite(I3,'frame3.bmp'); % saving into hard disc
I4=frame2im(mov(78)); 
I4=rgb2gray(I4); 
imwrite(I4,'frame4.bmp'); % saving into hard disc
I5=frame2im(mov(79)); 
I5=rgb2gray(I5); 
imwrite(I5,'frame5.bmp'); % saving into hard disc

%% Task2,3,4,5

clear all;
Iold=imread('frame4.bmp');  % reading 2 consecutive frames
Inew=imread('frame5.bmp');
Iold=mat2gray(Iold);        % convert to 0-1 values
Inew=mat2gray(Inew);        % convert to 0-1 values
IR=zeros(size(Iold));       % Initializing Reconcstucted image of the same size with zeros
I_no_motion=zeros(size(Iold));   % Initializing Image with no motion frames of the same size with zeros

% Finding the difference image
Idiff=Inew-Iold;
% figure(1);imshow(Idiff); title('Idiff before thresholding');
th=50/255;
Idiff(abs(Idiff)<=th)=0;

% divide the image area and check for motion 
bs=16; % block size
[N1,N2]=size(Idiff);    % Getting the dimensions of the image N1 corresponds to motion along Y N2 along X
Imotion=zeros(N1,N2);   % Initializing Image with motion frames of the same size with zeros

% Within For loops all the task 2,3,4,5 are excuted
for j=1:floor(N1/bs)
    for i=1:floor(N2/bs)
        s=sum(sum(Idiff((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs))); % to check if it is a motion block or not
        if (s==0)   % That is a static block
            
            I_no_motion((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs)=Iold((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs);
            no_motion((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs)=Iold((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs);   % some problems with the size due to floor function i am getting one rown and one col missing :)
            
        else        % the block is a motion block 
            
            Imotion((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs)=ones(bs,bs);
            % for each block one block of old image moves around
            Inew_block=Inew((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs);
            
            for yold=1:N1-bs+1
                
                for xold=1:N2-bs+1
                    
                    MAE(yold,xold)=sum(sum(abs(Inew_block-Iold(yold:yold+15,xold:xold+15))));
                    
                end
                
            end
            
            % find the index of MAE which gives the minimum value
            [b,a]=find(MAE==min(min(MAE)));
            % motion vector a in x direction, b in y direction
            MV(j,i,1)=(j-1)*bs+1-b; %dy
            MV(j,i,2)=(i-1)*bs+1-a; %dx
            r(j,i)=sqrt(MV(j,i,1)^2+MV(j,i,2)^2);   % find the magnitude (displacement) of the motion vector
                                                    
            
            IR((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs)=Iold(b:b+bs-1,a:a+bs-1);    %INTER processing(TASK4)
            I_no_motion((j-1)*bs+1:j*bs,(i-1)*bs+1:i*bs)=Iold(b:b+bs-1,a:a+bs-1);   %INTRA processing(TASK5)
            
        end  
    end 
end
I_final=I_no_motion;
clear I_no_motion;  % Just to save variable space
E_image=abs(Inew-I_final);

%% Task 6

MSE=(1/(N1*N2))*(sum(sum(E_image.^2))); % Calculating mean square error
PSNR=10*log10(1/MSE)                    % Calculating PeakSNR


%% Plotting

% r_resh=reshape(r,1,[]);
% figure;hist(r_resh,100);
% mean(r_resh)
% var(r_resh)
% std(r_resh)

% figure(2);imshow(Iold); title('Iold');
% figure(3);imshow(Inew); title('Inew');
% figure(4);imshow(Imotion); title('Imotion');
% figure(5);imshow(Idiff); title('Idiff after thresholding');
% figure(6);imshow(IR);title('INTER processed image');
% figure(7);imshow(no_motion);title('Image with only non motion blocks');
% figure(8);imshow(I_final);title('INTRA processed image');
% figure(9);imshow(30*E_image);title('30 times Enlarged Error Image');

