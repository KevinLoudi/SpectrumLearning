%Culster data according to divided channel
%Author: Zhu Gengyu
%Date: 2016/8/17

function BandLevel = BandCluster(Level, StartF, StopF)
  % 1710+0.2*(n-511) downlink
  [slots,freqs] = size(Level);
  %ratio = 0.2/0.025;
  %banditem = 1:ratio:freqs;
  bandindex = 1;
  count = 0;
  BandLevel = zeros(slots,floor(freqs/8));
  
  
   %for i = 1:slots
     %for j= 1:freqs 
    i=1; j=1;
     while(i<slots)
         while (j < freqs)
          if(mod(j,8)==1)||j~=1
             BandLevel(i,bandindex) = BandLevel(i,bandindex) +Level(i,j);
             count = count + 1;
          else
            BandLevel(i,bandindex) = BandLevel(i,bandindex)/count;
            count = 0;
            bandindex = bandindex + 1;
          end   
          i = i+1;
          j = j+1;
      end
  end
  figure(1);
  [t,f] = size(BandLevel);
  WaterFallPlot(f,t,BandLevel);
end