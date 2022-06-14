function i_comp = compres(i,width,height)

rect_block = 8;
for k = 1:width/rect_block
    for j = 1:height/rect_block
        I((j-1)*rect_block+1:j*rect_block,(k-1)*rect_block+1:k*rect_block) = dct2(i((j-1)*rect_block+1:j*rect_block,(k-1)*rect_block+1:k*rect_block));
    end
end

com_ra = 0.98;
forSort = reshape(I,1,width*height);
temp = sort(abs(forSort),'ascend');
th = (temp(round(com_ra*width*height)));

c = abs(I) > th;

I_comp = I.*c;


for k = 1:width/rect_block
    for j = 1:height/rect_block
        i_comp((j-1)*rect_block+1:j*rect_block,(k-1)*rect_block+1:k*rect_block) = idct2(I_comp((j-1)*rect_block+1:j*rect_block,(k-1)*rect_block+1:k*rect_block));
        
    end
end

