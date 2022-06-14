close all;
clear all;
clc;
%% step 1.1
fs=8000;%sampling freq
ts=2;%sound duration
CHN=1;%num of channel(mono type)
N=2*fs;%sound duration
sp=wavrecord(N,fs,CHN);%recording
%figure;plot(sp);
%wavplay(sp,fs);%listening
%wavwrite(sp,fs,'Myvowel');%Recorded sound written in file
sp=wavread('Myvowel.wav');%read again
%wavplay(sp,fs);%listening again
figure;plot(sp);%sound waveform
%% step 1.2
spb=sp(10000:10800);%picking 100ms segment(L=800samples)
p=10;%order of predictor
[coeff,var]=lpc(spb,p);%lpc applied
coeff(2:end);%filter coefficients
var;%variance(0.0057)
%figure;plot([coeff,var])%plotting after lpc
%% step 1.3
A=coeff(1:end);
ehat=filter(A,1,sp);%residual sequence
figure;
subplot(2,1,1);plot(sp,'b');title('Original Vowel');
subplot(2,1,2);plot(ehat,'r');title('Estimated Residual Sequence');

%% step 1.4
shat=filter(1,A,ehat);%resynthezied speech
figure;
subplot(2,1,1);plot(sp,'b');title('Original Vowel');
subplot(2,1,2);plot(shat,'r');title('Estimated Synthesized Vowel');
shat_normalized = shat/max(abs(shat));
%wavwrite(shat_normalized,fs,16,'MyVowel Resynthesized');%saving resynthezied tone
