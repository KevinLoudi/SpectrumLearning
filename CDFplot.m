%Calculate cdf of different distributions
%Author: Shirley
%Date: 2016/9/8

function []=CDFplot()
 pd = makedist('Normal');
 r = random(pd,[80,1]);
 p = cdf('Normal',r,1,4);
 cdfplot(p);

% pd = makedist('Poisson',lambda);
% p = cdf('Poisson',0:4,1:5);

% X = 1:200;
% Y = logncdf(X,4.5,0.1);
% func = @(fit,xdata)logncdf(xdata,fit(1),fit(2));
% fit = lsqcurvefit(func,[4 0.3],X,Y)

end
