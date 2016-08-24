%Calculate Channel Vacancy Duration through Channel State
%Author: Zhu Gengyu
%Date: 2016/7/20

function [Result]=CalculateCVD(ChannelState)
 CS = ChannelState;
 [Time,Channel] = size(CS);
 if (Time < 20)||(Channel < 2)
   error('Insufficient Input Data !!!');  
   return;
 end
 %set a variable to preserve CVD data
 CVD = cell(1,Channel);
 
 %for each channel, recongize the continuous '0' items
 %This is an excellent method in solve the problem
 for i = 1:Channel
  %select specific line according to channels
  a = CS(:,i); 
  temp = [];
  result = {};
  %obtain a bool-state of a (equal to '1' or not)
  %tmpCVD = zeros(Time);
  %if all items in the series equal '0', skip the calculation
  if(Time ~= find(a))
   while(~isempty(a))
    if a(1)~=0
        if(~isempty(temp))
            %if temp is empty, then it have no value last time 
            result = [result,{temp}];
        end 
        %if temp have value, means it is a 0 this time
        temp = [];
        flag = 0;
    else
        %a(1) equals 0
        temp = [temp,a(1)];
        %a vacancy means at least 5 mins duration
        flag = 1;
    end
    a(1) = [];
   end
  else
   result{1} = length(a);    
  end
  %calculate the number of results or "vacancy period"
  for k = 1:length(result)
    %how many vacancy periods a channel have
    tmpCVD(k) = length(result{k});  
  end
 %all "vacancy period" belongs to a specific channel
 CVD{1,i} = tmpCVD;
 end
 Result.ChannelNum = Channel;
 Result.TimeSlot = Time;
 Result.CVDcell = CVD;
end