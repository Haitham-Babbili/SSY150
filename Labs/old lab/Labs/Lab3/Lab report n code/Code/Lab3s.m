close all;
clear all;
clc;
%% Task1
video=aviread('Trees1.avi');    %Reading the video file
%movie(video);      %Playing movie in matlab
FN=length(video);   %Total number of frames in video(110 frames)
CIF=[];             %Initialization
CI=[];
I=[];
CIF=video(80:85);   %Extracting 5 consecutive image frames of video

for j=1:5
[I map]=frame2im(CIF(j));   %converting 5 video frames from video to images
I=mat2gray(rgb2gray(I));    %converting to gray scale image
CI=[CI I];
end
size(CI);

I1=CI(1:241,1:321);     %size of 1 image is [241 321]
I2=CI(1:241,322:642);   %consecutive image frames 
I3=CI(1:241,643:963);
I4=CI(1:241,964:1284);
I5=CI(1:241,1285:1605);

% imwrite(I1,'I1.bmp','bmp');%saving the images to disk
% imwrite(I2,'I2.bmp','bmp');
% imwrite(I3,'I3.bmp','bmp');
% imwrite(I4,'I4.bmp','bmp');
% imwrite(I5,'I5.bmp','bmp');

%% Task2,3,4,5
%step 2.1
Iold=I2;%loading 2 consecutive images
Inew=I3;
%step 2.2
Idiff=Inew-Iold;%difference
th=50/255;%setting threshold value
[R C]=size(Idiff);
for l=1:R
    for m=1:C
        if(abs(Idiff(l,m))<=th)
            Idiff(l,m)=0;
        end
    end
end
% step 2.3
blocksize=16;
Imotionblocks = zeros(size(Idiff));%Initializing for motion block
Istaticblocks=zeros(size(Iold));%Initializing static blocks with zeros
Imap=zeros(size(Iold));       % Initializing Reconcstucted image of the same size with zeros
BR=floor(R/blocksize);%dividing the image into blocks of 16*16
BC=floor(C/blocksize);

for j=1:BR
   for i=1:BC%checking for motion and static blocks
      temps=sum(sum(Idiff((j-1)*blocksize+1:j*blocksize, (i-1)*blocksize+1: i*blocksize)));
      if temps==0
          Istaticblocks((j-1)*blocksize+1:j*blocksize, (i-1)*blocksize+1: i*blocksize)=Iold((j-1)*blocksize+1:j*blocksize, (i-1)*blocksize+1: i*blocksize);
          staticblocks((j-1)*blocksize+1:j*blocksize,(i-1)*blocksize+1:i*blocksize)=Iold((j-1)*blocksize+1:j*blocksize,(i-1)*blocksize+1:i*blocksize);%just for plotting purpose    
      else
         Imotionblocks((j-1)*blocksize+1:j*blocksize, (i-1)*blocksize+1: i*blocksize)=ones(blocksize,blocksize);
         Inewblock=Inew((j-1)*blocksize+1:j*blocksize,(i-1)*blocksize+1:i*blocksize); 
           for yold=1:R-blocksize+1                
                for xold=1:C-blocksize+1
                    Ioldblock=Iold(yold:yold+15,xold:xold+15);
                    MAE(yold,xold)=sum(sum(abs(Inewblock-Ioldblock)));                    
                end
           end
       [x,y]=find(MAE==min(min(MAE)));%finding index value corresponding to minimum MAE
       %Finding best motion vector for block(L,M)
       MV(j,i,1)=(j-1)*blocksize+1-x; %dy
       MV(j,i,2)=(i-1)*blocksize+1-y; %dx
% Step 3.2

 r(j,i)=sqrt(MV(j,i,1)^2+MV(j,i,2)^2); %Magnitude(displacement)of the motion vector
 %figure;hist(r,max(r));title('Histogram of Motion vectore');
 Imap((j-1)*blocksize+1:j*blocksize,(i-1)*blocksize+1:i*blocksize)=Iold(x:x+blocksize-1,y:y+blocksize-1);    %INTER processing(TASK4)
 Istaticblocks((j-1)*blocksize+1:j*blocksize,(i-1)*blocksize+1:i*blocksize)=Iold(x:x+blocksize-1,y:y+blocksize-1);   %INTRA processing(TASK5)
      end
   end
end
Ifinal=Istaticblocks%reconstructed image
Errorimage=abs(Inew-Ifinal);%computing error image
%Plots
figure; imshow(Iold); title('Origanl Old image');
figure; imshow(Inew); title('Origanl New image');
figure; imshow(Idiff);title('Difference Image');%Images to include in report and threhold value=50/255=0.1961
figure; imshow(Imotionblocks); title('Imotion Image');
figure;imshow(Imap);title('INTER processed image');
figure;imshow(staticblocks);title('Image with only non motion blocks');
figure;imshow(Ifinal);title('Reconstructed image');
figure;imshow(30*Errorimage);title('30 times Enlarged Error Image');
r1=reshape(r,1,[]);
figure;hist(r1,100);
%include in report n comments
mean(r1);% (2.1043)
var(r1);%(43.3596)
std(r1);%(6.5848)
%For task 3:Image size: (sizey, sizex)=(241,321(as mentioned in task1aswell)),blocksize=16*16,No blocks in y direction=15 ; No blocks in xdirection=20

%% Task6
MSE=(1/(R*C))*(sum(sum(Errorimage.^2))); % Mean square error(0.0061)
PSNR=10*log10(1/MSE)                    % PSNR(22.1241)


