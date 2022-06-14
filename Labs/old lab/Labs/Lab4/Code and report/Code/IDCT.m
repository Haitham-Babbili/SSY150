function invimg=IDCT(quantizedv,orgimg)
L =length(orgimg);
% [R C]=size(orgimg);
% Blocksize=16;
% RB=R/Blocksize;                                  %TO make 16*16 blocks
% CB=C/Blocksize;
% %setting for compression
Rcompression = 0.5;                              %compression ratio
N=16*16;                                         %Block size
N1=round(Rcompression*N);                        %coefficients to remove from each block
Nc=N-N1;                                         %coefficients to retain in each block 
% for i=1:RB
%     for j=1:CB
%         IZ=dezigzag1dto2d(Z);                  %function call(inverse zigzag) 
%         Z1=IZ(1:Nc);
%         invimg=[Z1 zeros(1,N1)];               %padding zeros for removed dct coefficients
% %         %IDCT
% %         temp=invimg((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize);
% %         tempIDCT = idct2(temp);%applying inverse 2d dct to all 8*8 blocks and saving it in invNi
% %         invimg((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize) = tempIDCT;
% %          
%     end
% end
%figure;imshow (invimg);title('2D inverse block transformed DCT image');%Block based compressed image
N =16;
i =1;
for j = 0:N:L-N
    for l = 0:N:L-N
        iscan = zeros(1,N*N);
        iscan(1:Nc) = quantizedv((i-1)*Nc+1:i*Nc);
        iscan1(j+1:j+N,l+1:l+N) = dezigzag1dto2d(iscan);
        i =i+1;
    end
end

back =zeros(L,L);
for inc2 = 0:N:L-N
for inc = 0:N:L-N
for i=1+inc2:N+inc2
    for j =1+inc:N+inc
        back(i,j) = iscan1(i,j);            % Creating 16x16 Blocks for inverse transform
    end
end
    invimg(inc2+1:inc2+N,inc+1:inc+N) = idct2(back(inc2+1:inc2+N,inc+1:inc+N));      % Taking Inverse Transform
end
end