%Materials from Mathwork
%Author: Shirley
%Date: 2016/9/9

% http://cn.mathworks.com/help/stats/linearmixedmodel-class.html
% http://cn.mathworks.com/help/stats/mixed-effects-1.html


load carbig

X = [ones(406,1) Acceleration Horsepower];
Z = [ones(406,1) Acceleration];
Model_Year = nominal(Model_Year);
G = Model_Year;

lme = fitlmematrix(X,MPG,Z,G,'FixedEffectPredictors',....
{'Intercept','Acceleration','Horsepower'},'RandomEffectPredictors',...
{{'Intercept','Acceleration'}},'RandomEffectGroups',{'Model_Year'},...
'FitMethod','REML')