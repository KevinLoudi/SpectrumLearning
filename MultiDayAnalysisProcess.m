%Analsis Multi-day data
%Author: Zhu Gengyu
%Date: 2016/7/18

function MultiDayAnalysisProcess()
 %Analyz channel state
 Parameters.MaxSlotNum = 2000;
 Parameters.MaxChannelNum = 6000;
 Parameters.ExtremSize = 0.05;
 Parameters.SingalThershold = 30; %dB
  %load original several-day-all-timeslot data data 
 StartF = 1710; StopF = 1740;
 %StartF = 60; StopF = 137;
 filename = sprintf('MultiLevel_%s_%s.mat', num2str(StartF),num2str(StopF));
 if exist(filename,'file') ~= 2
   error('*.mat file do not exist!');  
 end
 load(filename); %vari- AllTimeSlots
 
%  StartItem=(80-60)/0.025; StopItem=(110-60)/0.025;
%  TmpLevel=MultiLevel.ByDay{1,1}.level(:,StartItem:StopItem);
 
 TmpLevel=MultiLevel.ByDay{1,1}.level(:,1:800); %1710
 csvwrite('DayLevel.csv',TmpLevel);
 
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
 Freq=Freq(1:800);
 %Freq=Freq(StartItem:StopItem);
 Time = 1:slotnum;
 WaterFallPlot(Freq,Time,Res.Occupancy);
 csvwrite('DayChannelState.csv',Res.Occupancy);
 %culster according to channel
 %BandCluster(AllTimeSlots,StartF,StopF);
 
end