close all;
clear all;
clc;
%% TASK 1

% Step 1.1
fs=8000;                            %sampling freq
ts=2;                               %sound duration
CHN=1;                              %num of channel(mono type)
N=2*fs;                             %sound duration
sp=wavrecord(N,fs,CHN);             %recording
%figure;plot(sp);
%wavplay(sp,fs);                    %listening
%wavwrite(sp,fs,'Myvowel');         %Recorded sound written in file
sp=wavread('Myvowel.wav');          %read again
%wavplay(sp,fs);                    %listening again
figure;plot(sp);                    %sound waveform
save Myvowel.mat

% step 1.2
spb=sp(10000:10800);                %picking 100ms segment(L=800samples)
p=10;                               %order of predictor
[coeff,var]=lpc(spb,p);             %lpc applied
coeff(2:end);                       %filter coefficients
var;                                %variance(0.0057)
%figure;plot([coeff,var])%plotting after lpc

% step 1.3
A=coeff(1:end);
ehat=filter(A,1,sp);                %residual sequence
figure;
subplot(2,1,1);plot(sp,'b');title('Original Vowel');
subplot(2,1,2);plot(ehat,'r');title('Estimated Residual Sequence');

% step 1.4
shat=filter(1,A,ehat);              %resynthezied speech
figure;
subplot(2,1,1);plot(sp,'b');title('Original Vowel');
subplot(2,1,2);plot(shat,'r');title('Estimated Synthesized Vowel');
shat_normalized = shat/max(abs(shat));
%wavwrite(shat_normalized,fs,16,'MyVowel Resynthesized');%saving resynthezied tone
%% TASK 2

% step 2.1
fs=8000;                            %sampling freq
ts=2;                               %sound duration
CHN=1;                              %num of channel
N=10*fs;                            %sound duration
sn=wavrecord(N,fs,CHN);             %recording
%figure;plot(sn);
%wavplay(sn,fs);                    %listening
%wavwrite(sn,fs,'Mysentence');%Recorded sound written in file
sn=wavread('Mysentence.wav');       %read again
%wavplay(sn,fs);                    %listening again
figure;plot(sn);                    %sound waveform

% step 2.2
p=10;                               %order of predictor
tb=20e-3;                           %20ms block
LS=length(sn);                      %length of speech signal(80,000samples)
L=160;                              %number os samples in 20ms block
Blocks=LS/L;                        %Blocks of 20ms(total=500 blocks)
                                    %dividing the sentence in 500 blocks
snf=[];
for i=1:Blocks
snb=sn((i-1)*L+1:i*L).';             %sentence divided in blocks of 20ms(160 samples in each block)
snf=[snf;snb];
end

lpccoeff=[];                        %applying lpc on each block
for i=1:Blocks
    coeff=lpc(snf(i,:),p)           %calculting the parameters for each block
    coeff=coeff(1:end);
    lpccoeff=[lpccoeff;coeff];    
end 
coefficients=size(lpccoeff);

% Step 2.3
ehat=zeros(1,length(sn));           %Initializing the residual sequence with zeros
for i=1:coefficients(1)
    ehat((i-1)*L+1:i*L)=filter(lpccoeff(i,:),1,sn((i-1)*L+1:i*L));  % Calculating residual sequence
end
figure;
plot(ehat,'r');title('Entire Residual');%Entire residual sequence
figure;
subplot(2,1,1);plot(sn(13000:13320),'b');title('Two Blocks of speech sentence');
subplot(2,1,2);plot(ehat(13000:13320),'b');title('Two corresponding Blocks of Residual sequence');
%% Step 2.4
shat_sn=zeros(1,length(ehat));      %initializing resynthesized signal
for j=1:coefficients(1)
    shat_sn((j-1)*L+1:j*L)=filter(1,lpccoeff(j,:),ehat((j-1)*L+1:j*L));  % Calculating re-synthesized speech
    ehat_block(j,:)=ehat((j-1)*L+1:j*L);
end
figure;
subplot(3,1,1);plot(sn,'b');title('Original speech Sentence');
subplot(3,1,2);plot(shat_sn,'r');title('Resynthesized speech Sentence');         
subplot(3,1,3);plot(ehat,'r');title('Entire residual sequence');
%wavwrite(shat_sn,fs,'Mysentence Resynthesized'); 
%%wavplay(shat_sn,fs);

%% TASK 3

% Step 3.1
ehat =ehat ;% residual sequence from task step 2.3
mod_ehat=[];
ehat_block=abs(ehat_block);
[temp,MSR]=sort(ehat_block,2,'descend');     % Estimating the 15 most significant excitation pulses
MSR=MSR(:,1:15);

% Step 3.2
mod_ehat_block=zeros(size(ehat_block));      %initializing
for ii=1:coefficients(1)
    mod_ehat_block(ii,MSR(ii,:))=ehat_block(ii,MSR(ii,:));    % Forming mod_ehat that is modified excitation
    mod_ehat=[mod_ehat mod_ehat_block(ii,:)];
end

modshat_sn=zeros(1,length(mod_ehat));       %initializing
for jj=1:coefficients(1)
    modshat_sn((jj-1)*L+1:jj*L)=filter(1,lpccoeff(jj,:),mod_ehat((jj-1)*L+1:jj*L));  % Calculating re-synthesized speech using modified excitation
    ehat_block(j,:)=ehat((j-1)*L+1:j*L);
end
%wavplay(modshat_sn,fs);
%wavwrite(modshat_sn,fs,'Mysentence Re-synthesized');
figure;
subplot(3,1,1);plot(sn,'b');title('Original speech Sentence');
subplot(3,1,2);plot(modshat_sn,'r');title('Resynthesized speech Sentence using modified excitation');         
subplot(3,1,3);plot(mod_ehat,'r');title('Modified residual sequence');

%% TASK 4

fs=8000;%sampling freq
ts=2;%sound duration
CHN=1;%num of channel
N=10*fs;%sound duration
%sn=wavrecord(N,fs,CHN);%recording
%figure;plot(sn);
%wavplay(sn,fs);%listening
%wavwrite(sn,fs,'Mysentence');%Recorded sound written in file
sn=wavread('Mysentence.wav');%read again

x = double(reshape(sn,160,length(sn)/160));
x = x.';

figure;
hold on
for i=30:59
    x_h = x(i,:).*hamming(160)';%To reduce gibbs effect
    y = [x_h zeros(1,1600)];%padding zeros more than number of samples so its easy to find peaks
    c = abs(fft(y,160));%Implementing equation 8
    c = log10(c);
    c = ifft(c);
    c = abs(c);
    c = i*0.5 + c;
    plot(c);
end





