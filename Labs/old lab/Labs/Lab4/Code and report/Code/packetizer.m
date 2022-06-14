function packet=packetizer(Index)
 k=127;                        %127 symbols per packet(size of source packet)
% % packet1=Index(1:k);           %Packet 1
% % packet2=Index(k+1:(2*k));     %packet 2
% % packet3=Index((2*k)+1:end);   %packet 3
% % packet3=[packet3 zeros(1,66)]; %Zero padding to make it same size of 127
 zIndex=[Index zeros(1,252)];      %Zero padding
 packetnumber=length(zIndex)/k;   %dividing in 3 packets
 packet=reshape(zIndex,k,packetnumber);  %Array of packets.No of rows  is equal to no of packets
 