%Analysis Time series,and realize Partial Periodic Frequenct Pattern Mining
%(PPPM) (������Ƶ��ģʽ�����ھ�)
%Author: Zhu Gengyu
%Date: 2016/7/18

function [Result] = TimeSeriesAnalysis(TimeSeries)
 if length(TimeSeries)== 0
   error('No Input Data!!!');
   return
 end
 TS = TimeSeries;
 [SlotNum,ChannelNum] = size(TS);
 %get basic parameters of the serie
end