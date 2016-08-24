%Plot a Freq-Time waterfall with color
%Author: Zhu Gengyu
%Date: 2016/7/12

function WaterFallPlot(FreqRange,TimeRange,TimeLevel)
 [Time,Freq] = size(TimeLevel);
 if Time ~= length(TimeRange) || Freq ~= length(FreqRange)
   error('The input data set did not match!!');
   return;
 end
 imagesc(FreqRange,TimeRange,TimeLevel);
 colorbar;
end