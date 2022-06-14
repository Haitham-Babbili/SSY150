function [Z_c CImage Z2]=DCT(orgimg)
[R C]=size(orgimg);
Blocksize=16;
RB=R/Blocksize;                                  %TO make 16*16 blocks
CB=C/Blocksize;
%setting for compression
Rcompression = 0.5;                              %compression ratio
N=16*16;                                         %Block size
N1=round(Rcompression*N);                        %coefficients to remove from each block
Nc=N-N1;                                         %coefficients to retain in each block  
Z_c =[];
Z2=[];
%step 4.3.2
for i=1:RB
    for j=1:CB
       temp=orgimg((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize);
       tempDCT = dct2(temp);                      %applying 2d dct to all 16*16 blocks and saving it in bbi
       CImage((i-1)*Blocksize+1:i*Blocksize,(j-1)*Blocksize+1:j*Blocksize) = tempDCT;
       Z=zigzag2dto1d(tempDCT);                   %function call(zigzag scanning)
       Z1 = Z(1:Nc);                               
       Z_c = [Z_c Z1];                             %Zigzag scanned DCT coefficients
       Z2=[Z2 Z];
    end
end
figure;imshow (CImage);title('2D block based transformed DCT image');

