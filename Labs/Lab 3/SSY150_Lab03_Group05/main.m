close all;
clear all;
clc

imag= imread('lena.bmp');   % Read the image
Imag=mat2gray(imag);        % Converting image format to intensity image
figure()
imshow(Imag)                % Displaying image
title('Original Image')

%% DCT Block1
[x,y]=size(Imag);
block_size=16;
comp_ratio=0.5;                     % compression ratio
pl_rate=0.03;                       % Packet loss rate
N=16*16;                            % pixels in one block
N1=round(comp_ratio*16^2);          % discarded dct coeficiences
Nc=N-N1;

% apply dct
dct = zeros(size(Imag));
for i=1:x/16
    for j=1:y/16
        block=Imag((i-1)*16+1:i*16,(j-1)*16+1:j*16);
        Block=dct2(block);        
        dct((i-1)*16+1:i*16,(j-1)*16+1:j*16)=Block;
    end
end


% zigzag scanning

signal=[];
for i=1:x/16
    for j=1:y/16        
        blocks=dct((i-1)*16+1:i*16,(j-1)*16+1:j*16);
        blocks_skem=zigzag(blocks);                   % Skem all blocks
        sequens=blocks_skem(1:Nc);                   
        signal=[signal,sequens];
    end
end

%% Quantization block

[index,quantized,codebook]=quantization(signal);


%% Packet

k=127;
packets_sym = packetizer(index,k); % number of packet symbole

%% Reed-Solomon encoder

m=8;  %Bits per symbol
n=2^m-1;
[codes msgwords codewords] = rs_code(packets_sym,m,k);

[nw, nl]=size(codes);


%% Interleaving

intrlv = interlever(codes);

%% Channel
method=input('Please enter 1 for packet loss or 2 for bit error:');
switch(method)    
    
           
    case{1}
        %5.1
%         codes_noisy=rsenc(msgwords, n, k);
%         codes_noisy=intrlv; % with interlever
        codes_noisy=codes; % without interlever
        e_packet=zeros(1, n);
        errorpacket=gf(e_packet,m);
        n_erropack=round(nw*pl_rate);
        loss_packets=randi([1,nw],1,n_erropack);
        for i=loss_packets
            codes_noisy(i, :) = errorpacket;
        end
%         [dc,nerrs,corrcodes]=rsdec(codes_noisy, n, k);
        
        case{2}
        % step5.2
%         codes = rsenc(msgwords, n, k);
        codes= intrlv; % with interlever
        error_detect=floor((n-k)/2);
%         t=randi([0,error_detect],1);
        t=60;
%         t=100;
        noise =randi( 2^m -1,nw,n).* randerr(nw, n, t);
        codes_noisy = codes + noise;
        [dc,nerrs,corrcodes]=rsdec(codes_noisy, n, k);
end
           


%% Deinterleaving

deintr = deinterleaver(codes_noisy,nw,nl);

%% Reed-Solomon decoder
dec_msg=rsdec(deintr,n,k);% decoded packets with interleaver

% dec_msg=rsdec(codes_noisy,n,k);% decoded packets without interleaver

isequal(dec_msg,codewords);


%% Depacket

depackets = depacketizer(dec_msg,index);

%% Dequantizer

% de_quantized=codebook(depackets+1);

de_quantized=codebook(depackets.x+1);

%%

% apply zigzag inverse
imag_inv=zeros(size(Imag));
for i=1:x/16
    for j=1:y/16
        block_num=16*(i-1)+j;
        sequens=de_quantized((block_num-1)*(Nc)+1:block_num*(Nc));
        templet=[sequens,zeros(1,N1)];
        
        block_inv=zigzag_inv(templet);
        imag_inv((i-1)*16+1:i*16,(j-1)*16+1:j*16)=block_inv;      
    end
end

% apply dct inverse
dct_inv=zeros(size(Imag));
for i=1:x/16
    for j=1:y/16
        templet_1 = imag_inv((i-1)*16+1:i*16,(j-1)*16+1:j*16);
        dct_inv((i-1)*16+1:i*16,(j-1)*16+1:j*16)=idct2(templet_1);
       
    end
end


e=abs(Imag-dct_inv);
PSNR = psnr(dct_inv,Imag);
MSSIM = ssim(dct_inv,Imag);

%%
figure()
set(gcf, 'Position',  [100, 100, 1420, 960])
subplot(1,2,1)
imshow(Imag)
title("Original image from source",'FontSize',16,'FontWeight','bold')
subplot(1,2,2)
imshow(dct_inv)
title("Reconstructed image at reciever",'FontSize',16,'FontWeight','bold')



