% Group 5 Project 1

close all
clear all
clc

%% --------- Task 2 --------- %%
% 2.1

Fs=10e3;   % sampling frequency
nuChannel=1; % amount of audio channel
rec_time=15;  % time of recording

% Create audio recorder
recorder_2 = audiorecorder(Fs,16,nuChannel);

% Get audio data from microphone
disp('The recording is started.')
recordblocking(recorder_2, rec_time);
disp('The recording is end.');

% regist audio data
reg_data = getaudiodata(recorder_2);

% save that signal in audio file 
audiowrite('MySentence1.wav',reg_data,Fs) 

% read saved file and replay
S=audioread('MySentence1.wav');
sound(reg_data,Fs);


figure
set(gcf, 'Position',  [100, 100, 1420, 960])
plot(S,'blue','linewidth',0.75)  % plot the recorded sound wave form 
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n)','FontSize',14,'FontWeight','bold')
title('Nonstationary Speech signal','FontSize',16,'FontWeight','bold')
legend('Original speech','FontSize',12,'FontWeight','bold')

%% 2.2

Fs=10e3;   % sampling frequency
p=12; % LPC filter order
%time of block sentence
T_block_sent=0.01;

% calculate block length (number of samples in each block)
L=Fs*T_block_sent;

% 
TotalBlocks=rec_time/T_block_sent;

LPC_analy=zeros(TotalBlocks,p+1);

for i=1:TotalBlocks
    LPC_analy(i,:)=lpc(S((i-1)*L+1:i*L),p);
end

%% 2.3

% Block-based estimation of residual sequence e(n):
ehat=zeros(size(S)); % creat empty residual cell
ehat(1:L)=filter(LPC_analy(1,:),1,S(1:L)); % 

for i=2:TotalBlocks
     for j=1:L
    temp=filter(LPC_analy(i,:),1,S((i-1)*L-p+1:i*L));
    ehat((i-1)*L+1:i*L)=temp(p+1:end);
     end
end

figure
plot(ehat,'red','linewidth',0.75)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('ehat(n)','FontSize',14,'FontWeight','bold')
title('Residual signal','FontSize',16,'FontWeight','bold')
legend('Residual signal','FontSize',12,'FontWeight','normal')



figure
subplot(2,1,1)
plot(S(65*L+1:70*L),'blue','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n)','FontSize',14,'FontWeight','bold')
title('Speech signal','FontSize',16,'FontWeight','bold')
legend('Original speech','FontSize',12,'FontWeight','normal')
subplot(2,1,2)
plot(ehat(65*L+1:70*L), 'red','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('ehat(n)','FontSize',14,'FontWeight','bold')
title('Residual signal','FontSize',16,'FontWeight','bold')
legend('Residual signal','FontSize',12,'FontWeight','normal')


figure
subplot(2,1,1)
plot(S(300*L+1:305*L),'blue','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n)','FontSize',14,'FontWeight','bold')
title('Speech signal','FontSize',16,'FontWeight','bold')
legend('Original speech','FontSize',12,'FontWeight','normal')
subplot(2,1,2)
plot(ehat(300*L+1:305*L),'red','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('ehat(n)','FontSize',14,'FontWeight','bold')
title('Residual signal','FontSize',16,'FontWeight','bold')
legend('Residual signal','FontSize',12,'FontWeight','normal')


%% 2.4
% Block-based speech re-synthesis:

shat=zeros(size(ehat));
shat(1:L)=filter(1,LPC_analy(1,:),ehat(1:L));

for i=2:TotalBlocks
    for j=1:L
        temp=flipud(shat((i-1)*L+j-p:(i-1)*L+j-1));
        shat((i-1)*L+j)=ehat((i-1)*L+j)-LPC_analy(i,2:end)*temp;
    end   
end


figure
subplot(3,1,1)
plot(S,'blue','linewidth',0.75)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n)','FontSize',14,'FontWeight','bold')
title('Original speech s(n)','FontSize',16,'FontWeight','bold')

subplot(3,1,2)
plot(shat,'blue','linewidth',0.75)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('shat(n)','FontSize',14,'FontWeight','bold')
title('The re-synthesized speech shat(n)l','FontSize',16,'FontWeight','bold')

subplot(3,1,3)
plot(ehat,'red','linewidth',0.75)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('ehat(n)','FontSize',14,'FontWeight','bold')
title('The residual sequence ehat(n)','FontSize',16,'FontWeight','bold')

audiowrite('S_ressynth1.wav',shat,Fs) 
ressynth=audioread('S_ressynth1.wav');

%soundsc(ressynth,Fs)


%% --------- Task 3 --------- %%
%  3.1

K=20;
% K=40;
mod_ehat=zeros(size(ehat));
for i=1:TotalBlocks
    [desc_vector, position]=sort(abs(ehat((i-1)*L+1:i*L)),'descend'); %sort abs(ehat) with descending
    K_position=position(1:K)+(i-1)*L;% take the location of K significant value
    mod_ehat(K_position)=ehat(K_position);
end


%% 3.2

n_shat=zeros(size(mod_ehat));
n_shat(1:L)=filter(1,LPC_analy(1,:),mod_ehat(1:L));
for i=2:TotalBlocks
    for j=1:L
        temp=flipud(n_shat((i-1)*L+j-p:(i-1)*L+j-1));% to get [s(n-1), s(n-2),...s(n-p)]
        n_shat((i-1)*L+j)=mod_ehat((i-1)*L+j)-LPC_analy(i,2:end)*temp;
    end   
end

figure
subplot(3,1,1)
plot(S,'blue','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('S(n)','FontSize',14,'FontWeight','bold')
title('Original signal for K=20','FontSize',16,'FontWeight','bold')


subplot(3,1,2)
plot(n_shat,'blue','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('New shat(n)','FontSize',14,'FontWeight','bold')
title('Re-synthesized signal for K=20','FontSize',16,'FontWeight','bold')


subplot(3,1,3)
plot(mod_ehat,'red','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('Modified ehat(n)','FontSize',14,'FontWeight','bold')
title('Modified residual signal for K=20','FontSize',16,'FontWeight','bold')

audiowrite('N_S_ressynth_K_20.wav',shat,Fs) 
ressynth=audioread('N_S_ressynth_K_20.wav');

%soundsc(n_shat,Fs)




%% --------- Task 4 --------- %%
% Read new speech block sentence  
[z,F] = audioread('bird.wav');

%time of block sentence
T_block_sent=0.01;

% calculate block length for new speech signal
L_N=F*T_block_sent;
figure 
hold on
% for i=1:TotalBlocks 
  for  i=1:20
    % create block of speech
    xi=z((i-1)*L_N+1:i*L_N);
    
    % cutting speech into blocks.
    xi=xi.*hamming(length(xi));

% zeros padding
    padd_fac=100;
    y=[xi;zeros(padd_fac*length(xi),1)];
   
    % obtain the cepstrum for each block of speech
%     c=abs(ifft(log(abs(fft(xi)))));
    c=abs(ifft(log(abs(fft(y)))));
   
    
    
    c2=c+i*0.5;
    plot(c2,'linewidth',1.5)
    set(gcf, 'Position',  [100, 100, 1420, 960])
    xlabel('Frequency','FontSize',14,'FontWeight','bold')
    ylabel('Speech blocks','FontSize',14,'FontWeight','bold')
    title('Block-based Cepstra','FontSize',16,'FontWeight','bold')
    
end





%% --------- Task 5 --------- %%
% Fs=10e3;
%p=12;
% LPC_analy=double(1400,12);
A=zeros(size(LPC_analy));
for i=1:TotalBlocks
    A(i,:)=lpc(n_shat((i-1)*L+1:i*L),p) ;       
end


% the bandwidth of speech signal
B=Fs/2;
% the discrete frequency
w_max=2*pi*B/Fs;
w=0:0.01:w_max;

% creat empty average distortion
d=zeros(1,TotalBlocks);


for i=1:TotalBlocks
    A_s=fft(LPC_analy(i,:),L);
    A_s=1./abs(A_s);        % spectrum of original signal
     
    A_shat=fft(A(i,:),L);
    A_shat=1./abs(A_shat);   % spectrum of re_synthesized signal
    
    d(i)=mean(10*log10(abs(A_s-A_shat).^2));
end

% P_s=abs(A_s).^2;
% Ps=linspace(0,w_max,L);
% 
% P_shat=abs(A_shat).^2;
% Pshat=linspace(0,w_max,L);

prim_1=fft(LPC_analy(100,:),L);
prim_1=1./abs(prim_1);
prim_2=fft(A(100,:),L);
prim_2=1./abs(prim_2);

P_s=abs(prim_1).^2;
Ps=linspace(0,w_max,L);

P_shat=abs(prim_2).^2;
Pshat=linspace(0,w_max,L);

figure
plot(Ps,P_s,'linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('w','FontSize',14,'FontWeight','bold')
ylabel('P(w)','FontSize',14,'FontWeight','bold')
hold on
plot(Pshat,P_shat,'linewidth',1.5)
legend({'$P_s(\omega_m)$','$P_{\bar{s}}(\omega_m)$'},'interpreter','latex','FontSize',12,'FontWeight','bold')
title('powerspectra Ps Vs Pshat','FontSize',16,'FontWeight','bold')

figure
plot(d,'blue','linewidth',1.5)
set(gcf, 'Position',  [100, 100, 1420, 960])
xlabel('Block(i)','FontSize',14,'FontWeight','bold')
ylabel('d(i)','FontSize',14,'FontWeight','bold')
title('Average distortion','FontSize',16,'FontWeight','bold')




