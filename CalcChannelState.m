%Calculate channel state from a set of wideband spectrum (Energy detection)
%Author: Zhu Gengyu
%Data format: 
% Time slot 1  890 100 ...
%           2  789 134 ...
%           3  345 210 ...
%          ...
%Frequency 801 802 803 ... MHz
%ChannelFilter. MaxSlots, MaxChannel, ExtremPartSize, SingalThershold
%ChannelState: '1' exist signal (at least MaxLevel-SingalThershold),
%otherwise '0',if MaxLevel - MinLevel < SingalThershold, break down

%Format: WideBandSpectrum should be an array [Time,Freq]
%Date: 2016/7/13

function [Results] = CalcChannelState(WideBandSpectrum,ChannelFilter)
 %The defalut parameters in Channel State evaluation
 if(nargin < 2)
   ChannelFilter.MaxSlotNum = 1000;
   ChannelFilter.MaxChannelNum = 1000;
   ChannelFilter.ExtremSize = 0.05; % 5% of the total data treated as extrem
   ChannelFilter.SingalThershold = 5; % Smallest signal strngth in consideration
 end
 %sense the timeslots and channels number of input data
 %exit if data set are illegeal
 [SlotNum,ChannelNum] = size(WideBandSpectrum);
 if (SlotNum < 2) || (ChannelNum < 10)
   error('Not Enough Input Data!!!');
   return;
 end
 if (SlotNum > ChannelFilter.MaxSlotNum)||(ChannelNum > ChannelFilter.MaxChannelNum)
   error('Too Many Input Data£¡ Stopping Analyzing');
   return;
 end
 
 WBS = WideBandSpectrum;
 clear WideBandSpectrum;
 %the number of all involved data
 TotalNum = SlotNum*ChannelNum;
 
 %reshape all data to a row and sort ascend
 tmWBS = reshape(WBS,1,TotalNum);
 tmpWBS = sort(tmWBS,'ascend');
 clear tmWBS; 
 %select the top 1% smallest data as noise
 ExtremDataNum = round(TotalNum*ChannelFilter.ExtremSize);
 MinLevel = mean(tmpWBS(1:ExtremDataNum));
 MaxLevel = mean(tmpWBS((TotalNum-ExtremDataNum):end));
 clear tmpWBS; 
 if (MaxLevel-MinLevel)<ChannelFilter.SingalThershold*10
   error('Uneable to distinguish singal with noise');  
   return;
 end
 %divided WideBandSpectrum into different channels
 %each cell correspond to a specific frequency
 %obtain a set to distinguish singal '1' with noise '0'
 DWBS = WBS>(MaxLevel-ChannelFilter.SingalThershold*10);   
 clear WBS;
 
 %Save analysis results
 Results.TimeSlotNum = SlotNum;
 Results.ChannelNum = ChannelNum;
 Results.Occupancy = DWBS;
 save('CS.mat','Results');
end