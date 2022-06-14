function MV = motion_Vec(input_block,y_begin,x_begin,width,height,img)
error = 1000;
for x_dir = 1:width-8
    for y_dir = 1:height-8
        permint_err = sum(sum(abs(input_block - img(y_dir:y_dir+7,x_dir:x_dir+7))));
        if permint_err < error
            error = permint_err;
            MV = [x_dir-x_begin,y_dir-y_begin];
        
        end           
    end
end









