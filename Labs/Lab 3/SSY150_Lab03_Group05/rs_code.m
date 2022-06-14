function [codes msgwords codewords] = rs_code(packets,m,k)

n=2^m-1;                      %codeword length
msgwords=gf(packets,m);       %represent packets using glaois array

codes=rsenc(msgwords, n, k);  %RS encoding
msgwords;
codewords=codes.x;            %Extract rows of codewords from GF array

end

