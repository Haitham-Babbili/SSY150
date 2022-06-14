function deintr = deinterleaver(codes_noisy,nw,nl)

data=reshape(codes_noisy.',1,[]);
inv_interleaver=matdeintrlv(data,nw,nl);
deintr=reshape(inv_interleaver,nl,nw);
deintr=deintr.';
end

