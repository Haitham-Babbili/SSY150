%% Task 1
close all;
clear all;
clc

t=[0:0.1:10*pi];
signal=sin(t);

[index,quantized,codebook]=quantization(signal);


figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
plot(t,signal,'linewidth',1.5)
hold on
plot(t,quantized,'^')
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('Frequency','FontSize',14,'FontWeight','bold')
title('Original Signal and Quantized Signal','FontSize',16,'FontWeight','bold')
legend('Sin(t)','Quantiz','FontSize',12,'FontWeight','bold')
%% Task 2
k=127;
packets = packetizer(index,k);
 
% Depacketizer

depackets = depacketizer(packets,index);

% Dequantized
recon_signal = codebook(depackets+1);

figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
plot(t,signal,'linewidth',1.5)
hold on
plot(t,recon_signal,'>')
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('Frequency','FontSize',14,'FontWeight','bold')
title('Original Signal and Dequantized after Depacketization','FontSize',16,'FontWeight','bold')
legend('Sin(t)','Depacketizer','FontSize',12,'FontWeight','bold')

