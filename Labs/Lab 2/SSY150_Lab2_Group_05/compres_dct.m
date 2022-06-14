function F = compres_dct(F,com_ra)
    th=ceil(com_ra*size(F,1)*size(F,2));
    vec_dct=F(:);
    temprer=sort(abs(vec_dct));
    F(abs(F)<temprer(th))=0;
end
