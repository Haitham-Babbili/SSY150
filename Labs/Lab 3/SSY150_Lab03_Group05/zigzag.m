function scan_vector=zigzag(blocks)

[x, y]=size(blocks);
scan_vector=zeros(1,y*y);
scan_vector(1)=blocks(1,1);
a=1;
for k=1:2*y-1
    
    if k<=y
        if mod(k,2)==0   
            f=k;
            for h=1:k
                scan_vector(a)=blocks(h,f);
                a=a+1;
                f=f-1;
            end
        else 
            h=k;
            for f=1:k
                scan_vector(a)=blocks(h,f);
                a=a+1;
                h=h-1;
            end
        end
    else
        if mod(k,2)==0 
            p=mod(k,y);
            f=y;
            for h=p+1:y
                scan_vector(a)=blocks(h,f);
                a=a+1;
                f=f-1;
            end
        else
            p=mod(k,y);
            h=y;
            for f=p+1:y
                scan_vector(a)=blocks(h,f);
                a=a+1;
                h=h-1;
            end
        end
    end
end

end