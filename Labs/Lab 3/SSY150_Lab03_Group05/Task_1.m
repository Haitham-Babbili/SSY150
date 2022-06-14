%% Task 1
close all;
clear all;
clc

t=[0:0.1:10*pi];
signal=sin(t);

[index,quantized,codebook]=quantization(signal);
recon_signal=codebook(index+1);
figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
plot(t,quantized,'linewidth',1.5)
hold on
plot(t,recon_signal,'^')
xlabel('Time','FontSize',14,'FontWeight','bold')
ylabel('Frequency','FontSize',14,'FontWeight','bold')% step 1.4
title('Quantized Signal vs Dequantized','FontSize',16,'FontWeight','bold')
legend('Quantiz','Dequantized','FontSize',14,'FontWeight','bold')
