%Author: Zhu Gengyu 2016/7/6
%对于输入矩阵的每一列做归一化，归一化范围[Low,High]
function [Res,Dim] = Normalize(Input,Low,High)
if(nargin == 1 & length(Low) ~= 1 & length(High)~= 1)
    return;
end
if(nargin<3)
   %给定默认的归一化范围
   Input = [1.5,2.3;1.1,3.4;5.7,2.5]; 
   Low = 0;
   High = 1;
   disp('Inaccessible enough data,apply default data');
end
if(nargin>3)
   disp('Too many input parameters'); 
end
 setrange = High - Low;
 minvalue = min(Input')';
 maxvalue = max(Input')';
 [rownum,colnum] = size(Input);
 tmpInput = zeros(size(Input));
 oneQ = ones(1,colnum);
 
 equal = minvalue==maxvalue;
 nequal = ~equal;
 if sum(equal) ~= 0
     warning('Part colnum maximums and minimums are equal,their inputs will not be transformed')
     min0 = minvalue*nequal - 1*equal;
     max0 = maxvalue*nequal + 1*equal;
 else
     min0 = minvalue;
     max0 = maxvalue;
 end
 
 Res = (High-Low)*(Input-min0*oneQ)./((max0-min0)*oneQ)-Low;
 
%  %对每一列进行归一化
%  for i= 1:colnum
%    maxvalue = max(Input(:,i))*ones(rownum,1);
%    minvalue = min(Input(:,i))*ones(rownum,1);
%    range = maxvalue - minvalue;
%    tmpInput(:,i) = setrange*((Input(:,i)-minvalue)./range)+Low;
%  end
 Dim = size(Res);
end