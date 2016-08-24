%Author: Zhu Gengyu
%Date: 2016/8/17
%Propose: Analyz Time State Evolution

function [Res] = HMMAnalyz()
  TRANS = [.9 .1; .05 .95;];
  EMIS = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6;...
7/12, 1/12, 1/12, 1/12, 1/12, 1/12];
  [seq,states] = hmmgenerate(1000,TRANS,EMIS);
end