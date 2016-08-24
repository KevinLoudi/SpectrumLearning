%Distribution analysis
%Author: Zhu Gengyu
%Date: 2016/7/14

function [DistriModel] = DistriAnalysis(Level)
 if length(Level)== 0
    error('No Input Data!!!');
    return;
 end
 %calculate the stage num in hist, no more than 100
 Stage = length(Level)/10;
 if Stage > 100
     Stage = 100;
 end
 %hist display
 H = hist(Level,Stage);
 %calcule the sample distribution
 cdf = zeros(1,length(H));
 for k = 1:length(H)
    cdf(k) = sum(H(1:k));
 end
 %save calculate results
 DistriModel.Cdf = cdf;
 DistriModel.Hist = H;
 DistriModel.Len = length(Level);
 DistriModel.StageNum = Stage;
end