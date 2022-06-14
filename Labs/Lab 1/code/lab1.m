% Group 5 Project 1
close all
clear all
clc

%--------- Task 1 ---------%
%% 1.1


% Create audio recorder
Fs=10e3; % sampling frequency
nuChannel=1; % amount of audio channel
recorder = audiorecorder(Fs,8,nuChannel);

% Get audio data from microphone
disp('The recording is started.')
recordblocking(recorder, 2);
disp('The recording is end.');
res_data = getaudiodata(recorder);

% save that signal in audio file 
audiowrite('MyVowel.wav',res_data,Fs) 

% read saved file and replay
info_signal= audioread('MyVowel.wav');
sound(res_data,Fs);

%length(res_data)% This gives 24000 samples
%  soundsc(res_data,Fs)
figure
plot(info_signal)  % plot the recorded sound wave form 
title('Stationary Speech signal')
legend('Original speech')

%% 1.2

Fs=10e3; % sampling frequency

p=12; % LPC Filter order

% speech block of 300ms
T_block_sent=0.3;

% create random noise
noise=randi([1,20000],1);

% sample size (number of samples in block)
samp_size=Fs*T_block_sent; 

% all signal block
sig_block=info_signal(noise:noise+samp_size-1);

[a,var]=lpc(sig_block,p);


%% 1.3

% calculat the residual e(n)
e_residual = filter(a,1,info_signal); 

%plot original audio signal versis residuals
figure
plot(info_signal)
hold on
plot(e_residual)
 set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n) Vs ehat(n)','FontSize',14,'FontWeight','bold')
title('Speech signal Vs Residual signal','FontSize',16,'FontWeight','bold')
legend('Original speech', 'Residual signal','FontSize',12,'FontWeight','bold')
hold off
%% 1.4

%re-synthesized audio signal
shat=filter(1,a,e_residual);

%plot original audio signal versis re-synthesized audio signal
figure
set(gcf, 'Position',  [100, 100, 1420, 960])
plot(info_signal,'-','LineWidth',1.5)
hold on
plot(shat)
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n) Vs shat(n)','FontSize',14,'FontWeight','bold')
title('Speech signal Vs Resynthesized signal','FontSize',16,'FontWeight','bold')
legend('Rriginal speech', 'Resynthesized signal','FontSize',12,'FontWeight','bold')
hold off

audiowrite('ressynth.wav',shat,Fs) 
ressynth=audioread('ressynth.wav');
sound(shat,Fs)



