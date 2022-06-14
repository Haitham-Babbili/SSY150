function intrleaver = interlever(codes)
data=reshape(codes.',1,[]);

[n_row,n_colum]=size(codes);
intrlvd=matintrlv(data,n_row,n_colum);

intrleaver=reshape(intrlvd,n_colum,n_row);
intrleaver=intrleaver.'; 

end

