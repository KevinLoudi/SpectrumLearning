%Abstract partial CVD for analysis
%Author: Zhu Gengyu
%Date: 2016/8/13

function CvdAnalysis(StartF,StopF)
   if exist('CVD.mat','file') ~= 2 || exist('AllTimeSlotinOne.mat','file') ~= 2
       return error('*.mat file do not exist!'); 
   end
   load('CVD.mat');
   load('AllTimeSlotinOne.mat','file') ;
   StartItem = (StartF-)
end