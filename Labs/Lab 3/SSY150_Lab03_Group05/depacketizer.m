function depackets = depacketizer(packets,index)

temp=[];                                 % empty templet matrix 
depackets = reshape(packets.',1,[]);   % Resize the packets to fill the matrix
depackets = depackets(1:length(index));  % depacketize the signal 

end

