function Index=depacketizer(packet)
packet1=[];
for i=1:length(packet)
    x=packet(i,:);
    packet1=[packet1 x];
end
% packet1=packet(:,1);
% packet2=packet(:,2);
% packet3=packet(:,3);
% packet=[packet1 packet2 packet3]; %Making one long vector of all 3 packets of size[1,381]
Index=packet1(1:32768);              %Removing zero padding done in packetizer function


