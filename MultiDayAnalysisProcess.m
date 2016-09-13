%Analsis Multi-day data
%Author: Zhu Gengyu
%Date: 2016/7/18

function MultiDayAnalysisProcess()
 %Analyz channel state
 Parameters.MaxSlotNum = 2000;
 Parameters.MaxChannelNum = 6000;
 Parameters.ExtremSize = 0.05;
 Parameters.SingalThershold = 15; %dB
  %load original several-day-all-timeslot data data 
 StartF = 1710; StopF = 1740;
 filename = sprintf('MultiLevel_%s_%s.mat', num2str(StartF),num2str(StopF));
 if exist(filename,'file') ~= 2
   error('*.mat file do not exist!');  
 end
 load(filename); %vari- AllTimeSlots
 
 TmpLevel=MultiLevel.ByDay{1,2}.level;
 Res = CalcChannelState(TmpLevel,Parameters);
 figure(1);
 %Demostrate channel state
 %contoutf(Res);
 %show the channel state
 StartF = MultiLevel.Info.StartFreq;
 StopF = MultiLevel.Info.StopFreq;
 StepF = MultiLevel.Info.StepFreq;
 figure(1);
 [slotnum,freqnum] = size(TmpLevel);
 Freq = StartF:StepF:(StopF-StepF);
 Time = 1:slotnum;
 WaterFallPlot(Freq,Time,Res.Occupancy);
 %culster according to channel
 %BandCluster(AllTimeSlots,StartF,StopF);
 
end

function K-meansSeprate(Level)
   

end