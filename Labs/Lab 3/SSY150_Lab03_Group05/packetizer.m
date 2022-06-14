function packets = packetizer(index,k)

row_number=ceil(size(index,2)/k);

packets=zeros(row_number,k);

    for i=1:row_number
        if i*k<=size(index,2)
            packets(i,:)=index((i-1)*k+1:i*k);
        else
            packets(i,1:size(index,2)-(i-1)*k)=index((i-1)*k+1:end);
        end

    end
end

