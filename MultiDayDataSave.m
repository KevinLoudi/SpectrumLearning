%Save multi-day data into .mat file
%Author: Zhu Gengyu
%Date: 2016/7/19

function MultiDayDataSave()
 clear;
 clc;
 %Path = 'E:\\tmpData\\825-960\\%s\\02';
 Path ='D:\\Code\\Matlab\\SpectrumLearning\\Data\\OriginData\\1710-1960\\%s\\02';
 StartF = 1710; 
 StopF = 1740;
 StepF = 0.025;
 DayArray = {'20151216','20151217','20151218','20151219','20151220','20151221','20151222'};
 %Read data day by day if the "Path" exist locally
 [MultiLevel] = MultiDaySpectrumReader(Path,DayArray,StartF,StopF)
 %Save Data
 %  tmpname = '%s_%s.mat';
 %  filename = sprintf(tmpname,num2str(StartF),num2str(StopF));
 %  if exist(filename,'file') ~= 2
 %    error('*.mat file do not exist!');  
 %  end
 %  load(filename);
 %save all level data in allLevel and clear reducant variable
 MultiLevel.Info.StartFreq = StartF;
 MultiLevel.Info.StopFreq = StopF;
 MultiLevel.Info.StepFreq = StepF;
 cur_time = fix(clock);
 time_str = sprintf('%.4d-%.2d-%.2d:%.2d:%.2d:%.2d:%.2d',cur_time(1),cur_time(2),cur_time(3),cur_time(4),cur_time(5),cur_time(6));
 MultiLevel.Info.BuildTime = time_str;
 filename = sprintf('MultiLevel_%s_%s.mat', num2str(StartF),num2str(StopF));
 save(filename,'MultiLevel');
end