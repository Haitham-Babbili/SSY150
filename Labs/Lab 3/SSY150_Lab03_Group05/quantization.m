function [index,quantized,codebook]=quantization(signal)


left_value=min(signal);
right_value=max(signal);


partition=linspace(left_value,right_value,257);  % Decision threshold vector
codebook=linspace(left_value,right_value,256);   %Reconstruction levels

[index,quantized]=quantiz(signal,partition(2:end-1),codebook);   %scalar quantization
codebook=linspace(left_value,right_value,256);
                                  
end




