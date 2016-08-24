%Data Analysis
%Author: Zhu Gengyu
%Date: 2016/7/12

function AnalysisProcess()
 clear;
 clc;
 Path = 'E:\\tmpData\\2010-2150\\%s\\02';
 %Path = 'D:\\ScanData\\02';
 StartF = 2010; 
 StopF = 2150;
 StepF = 0.025;
 Level = SpectrumReader(Path,StartF,StopF,StepF);
 save('TestAllLevelData.mat','Level');
 save('TestLevelData.mat','Level');
 DayArray = {'20151216','20151217','20151218','20151219','20151220','20151221','20151222'};
 %Read data day by day
 for i = 1:length(DayArray)
   ThisPath = sprintf(Path,DayArray{i});  
   tmpLevel = SpectrumReader(ThisPath,StartF,StopF,StepF);
   MultiLevel{i} = tmpLevel;
 end
 
 %MultiLevel = MultiDaySpectrumReader(Path,DayArray,StartF,StopF);
 save('ThreeDayLevel','MultiLevel');

 
 load('TestAllLevelData.mat');
 len = length(Level);
 %evaluate channel state
 ChannelState = CalcChannelState(Level);
 %plot channel state waterfall
 Freq = StartF:StepF:StopF;
 Time = 1:len;
 figure(1)
 WaterFallPlot(Freq,Time,ChannelState.Occupancy);
 
 
 for i = 1:len
   TimeLevel(i,:) = double(Level{i}./10);
   %循环计算相关性（第一帧和最后一帧？？？）
   if i == 1
     %第一帧
     tmpcor1 = corrcoef(double(Level{1}./10),double(Level{2}./10));
     tmpcor2 = corrcoef(double(Level{1}./10),double(Level{len}./10));
     %h = 0 not reject the null hyphothesis at the default 5% significance
     %level
     %p [0,1] small values of p cast double on the vadlidity of the null
     %hyphothesis
     %ci Confidence interval for the difference in population means of x
     %and y, containing the lower and upper boundaries of the
     %100*(1-alpha)%
     %stats Test statistics, Value of the test; degrees of the freedom in
     %the test; pooled estimate of population standard deviation
     [hypo,p,ci,stats] = ttest2(double(Level{1}./10),double(Level{len}./10));
   else if i == len
     %最后一帧
     tmpcor = corrcoef(double(Level{len}./10),double(Level{1}./10));
     tmpcor2 = corrcoef(double(Level{len}./10),double(Level{len-1}./10));
     [hypo,p,ci,stats] = ttest2(double(Level{len}./10),double(Level{1}./10));
       else
       tmpcor1 = corrcoef(double(Level{i}./10),double(Level{i+1}./10));
       tmpcor2 = corrcoef(double(Level{i}./10),double(Level{i-1}./10));
       [hypo,p,ci,stats] = ttest2(double(Level{i}./10),double(Level{i-1}./10));
       end
   end
   %Averaged ratio of context
   Rev(i) = (tmpcor1(1,2)+tmpcor2(1,2))/2;
   H(i) = hypo;
   ConfidUp(i) = (ci(1)*100-5)*0.01;
   ConfidDown(i) = (ci(2)*100-5)*0.01;
 end
 Freq = StartF:StepF:(StopF);
 Time = 1:length(Level);
 %Demo the results
 figure(2);
 subplot(2,1,1);
 WaterFallPlot(Freq,Time,TimeLevel);
 xlabel('Freq/MHz');
 ylabel('Timeslot');
 title('Waterfall')
 subplot(2,1,2);
 plot(Time,Rev); hold on;
 stem(Time,H,'r');hold on;
 xlabel('Timeslot');
 ylabel('Correlation Ratio');
 title('Correlation between Context Timeslot');
 axis([0 len+2 0.20 1.02])
 %T-test for difference evaluatioion
 
 %Obtain the statistical properties
 %hist
 figure(3);
 for i = 1:len
  [DistriModel] = DistriAnalysis(double(Level{i}./10));
  plot(DistriModel.Cdf,'r-.'); hold on;
 end
 
 %利用SVM对时间序列进行回归分析
%  TL = TimeLevel(2:len)';
%  TLX = TimeLevel(1:len-1);
%  [TLS,Dim] = Normalize(TL,-1,1);
%  [TLXS,Dim] = Normalize(TLX,-1,1);
%  %获得SVM精确参数
%  [bestmse,bestc,bestg] = SVMcgForRegress(TLS,TLXS,-4,4,-4,4,3,0.5,0.5,0.05);
%  %SVM训练
%  cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
%  model = svmtrain(TLS,TLXS,cmd);
%  %SVM网络回归分析
%  [predict,mse] = svmpredict(TLS,TLXS,model);
 i = 0;
end