%Calculate channel state from a set of wideband spectrum (Energy detection)
%Author: Zhu Gengyu
%Data format: 
% Time slot 1  890 100 ...
%           2  789 134 ...
%           3  345 210 ...
%          ...
%Frequency 801 802 803 ... MHz
%ChannelFilter. MaxSlots, MaxChannel, ExtremPartSize, SingalThershold
%ChannelState: '1' exist signal (at least MaxLevel-SingalThershold),
%otherwise '0',if MaxLevel - MinLevel < SingalThershold, break down

%Format: WideBandSpectrum should be an array [Time,Freq]
%Date: 2016/7/13

function [Results] = CalcChannelState(WideBandSpectrum,ChannelFilter)
 %The defalut parameters in Channel State evaluation
 if(nargin < 2)
   ChannelFilter.MaxSlotNum = 1000;
   ChannelFilter.MaxChannelNum = 1000;
   ChannelFilter.ExtremSize = 0.05; % 5% of the total data treated as extrem
   ChannelFilter.SingalThershold = 10; % Smallest signal strngth in consideration
 end
 %sense the timeslots and channels number of input data
 %exit if data set are illegeal
 [SlotNum,ChannelNum] = size(WideBandSpectrum);
 if (SlotNum < 2) || (ChannelNum < 10)
   error('Not Enough Input Data!!!');
   return;
 end
 if (SlotNum > ChannelFilter.MaxSlotNum)||(ChannelNum > ChannelFilter.MaxChannelNum)
   error('Too Many Input Data£¡ Stopping Analyzing');
   return;
 end
 
 WBS = WideBandSpectrum;
 clear WideBandSpectrum;
 %the number of all involved data
 TotalNum = SlotNum*ChannelNum;
 
 %reshape all data to a row and sort ascend
 tmWBS = reshape(WBS,1,TotalNum);
 tmpWBS = sort(tmWBS,'ascend');
 clear tmWBS; 
 %select the top 1% smallest data as noise
 ExtremDataNum = round(TotalNum*ChannelFilter.ExtremSize);
 MinLevel = mean(tmpWBS(1:ExtremDataNum));
 MaxLevel = mean(tmpWBS((TotalNum-ExtremDataNum):end));
 clear tmpWBS; 
 if (MaxLevel-MinLevel)<ChannelFilter.SingalThershold*10
   error('Uneable to distinguish singal with noise');  
   return;
 end
 %divided WideBandSpectrum into different channels
 %each cell correspond to a specific frequency
 %obtain a set to distinguish singal '1' with noise '0'
 
 %2016-9-14 implement OSTU to calculate the thershold
 X = WBS(:);
 MaxLevel=max(X);
 MinLevel=min(X);
 Y = mapminmax(WBS,0,255);
 Thershold=MaxLevel-(MaxLevel-MinLevel)*0.3;
 %Thershold=graythreshmo(Y);
 %Thershold=(Thershold/255)*(MaxLevel-MinLevel)+MinLevel;
 DWBS=WBS>Thershold;
 %DWBS = WBS>(MaxLevel-ChannelFilter.SingalThershold*10);   
 clear WBS;
 
 %Save analysis results
 Results.TimeSlotNum = SlotNum;
 Results.ChannelNum = ChannelNum;
 Results.Occupancy = DWBS;
 %save('CS.mat','Results');
end


function [level, em] = graythreshmo(I)
%GRAYTHRESH Global image threshold using Otsu's method.
%   LEVEL = GRAYTHRESH(I) computes a global threshold (LEVEL) that can be
%   used to convert an intensity image to a binary image with IM2BW. LEVEL
%   is a normalized intensity value that lies in the range [0, 1].
%   GRAYTHRESH uses Otsu's method, which chooses the threshold to minimize
%   the intraclass variance of the thresholded black and white pixels.
%
%   [LEVEL, EM] = GRAYTHRESH(I) returns effectiveness metric, EM, as the
%   second output argument. It indicates the effectiveness of thresholding
%   of the input image and it is in the range [0, 1]. The lower bound is
%   attainable only by images having a single gray level, and the upper
%   bound is attainable only by two-valued images.
%
%   Class Support
%   -------------
%   The input image I can be uint8, uint16, int16, single, or double, and it
%   must be nonsparse.  LEVEL and EM are double scalars. 
%
%   Example
%   -------
%       I = imread('coins.png');
%       level = graythresh(I);
%       BW = im2bw(I,level);
%       figure, imshow(BW)
%
%   See also IM2BW, IMQUANTIZE, MULTITHRESH, RGB2IND.

%   Copyright 1993-2015 The MathWorks, Inc.

% Reference:
% N. Otsu, "A Threshold Selection Method from Gray-Level Histograms,"
% IEEE Transactions on Systems, Man, and Cybernetics, vol. 9, no. 1,
% pp. 62-66, 1979.


validateattributes(I,{'uint8','uint16','double','single','int16'},{'nonsparse'}, ...
              mfilename,'I',1);

if ~isempty(I)
  % Convert all N-D arrays into a single column.  Convert to uint8 for
  % fastest histogram computation.
  %I = im2uint8(I(:)); %2016-9-14 temporal change Zhu
  I=I(:);
  num_bins = 256;
  counts = imhist(I,num_bins);
  
  % Variables names are chosen to be similar to the formulas in
  % the Otsu paper.
  p = counts / sum(counts);
  omega = cumsum(p);
  mu = cumsum(p .* (1:num_bins)');
  mu_t = mu(end);
  
  sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

  % Find the location of the maximum value of sigma_b_squared.
  % The maximum may extend over several bins, so average together the
  % locations.  If maxval is NaN, meaning that sigma_b_squared is all NaN,
  % then return 0.
  maxval = max(sigma_b_squared);
  isfinite_maxval = isfinite(maxval);
  if isfinite_maxval
    idx = mean(find(sigma_b_squared == maxval));
    % Normalize the threshold to the range [0, 1].
    %level = (idx - 1) / (num_bins - 1); temporal change
    level=idx-1;
  else
    level = 0.0;
  end
else
  level = 0.0;
  isfinite_maxval = false;
end

% compute the effectiveness metric
if nargout > 1
  if isfinite_maxval
    em = maxval/(sum(p.*((1:num_bins).^2)') - mu_t^2);
  else
    em = 0;
  end
end
end


