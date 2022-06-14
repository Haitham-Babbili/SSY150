function scan_vector=zigzag_inv(templet)
% inverse transform from the zigzag format to the matrix form


N=sqrt(length(templet));
scan_vector=zeros(N,N);
scan_vector(1,1)=templet(1);
a=1;
for k=1:2*N-1
    
    if k<=N
        if mod(k,2)==0
            f=k;
            for h=1:k
                scan_vector(h,f)=templet(a);
                a=a+1;
                f=f-1;
            end
        else
            h=k;
            for f=1:k
                scan_vector(h,f)=templet(a);
                a=a+1;
                h=h-1;
            end
        end
    else
        if mod(k,2)==0  
            p=mod(k,N);
            f=N;
            for h=p+1:N
                scan_vector(h,f)=templet(a);
                a=a+1;
                f=f-1;
            end
        else 
            p=mod(k,N);
            h=N;
            for f=p+1:N
                scan_vector(h,f)=templet(a);
                a=a+1;
                h=h-1;
            end
        end
    end
end

end