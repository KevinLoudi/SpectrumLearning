%Read Out Spectrum Data from several days (one station)
%Author: Zhu Gengyu
%Date: 2016/7/18
%Path format: 'Y:\\20-3000\\%s\\03' DayArray should be string

function [MultiLevel] = MultiDaySpectrumReader(Path,DayArray,StartFreq,StopFreq,Info)
if(nargin<5)
  Info.Maxsize = 1000; 
end
%index for the time slot num
datasize = 1;
for i = 1:length(DayArray) 
  Day = DayArray{i};  
  %get the file path for a specific day
  DayPath = sprintf(Path,Day);
  %find all files in the path
  dirinfo = dir(DayPath);
  index = 1;
  %Loop for all files within the path
  for k = 1:length(dirinfo)
     %point to this-file
     thisdir = dirinfo(k).name;
     %get the path for this-file
     filename = [DayPath,'\',thisdir];
     %check if this-file really exist
     if exist(filename,'file') == 2
        %Read out data from a *.argus file
        tmpLevel = ArgusReader(filename,StartFreq,StopFreq);
        %tmpLevel.SampleTime=floor(str2num(thisdir(1:12)));
        tmpLevel.SampleTime=thisdir(1:12);
        %Combine the newly read data and existed data in Level
        Level{i}(index,:) = tmpLevel;
        %Count the accessed data
        datasize = datasize + 1;
        index = index + 1;
        if(index > Info.Maxsize)
            break;
        end
     end
  end 
end
MultiLevel.Level = Level;
MultiLevel.Day = length(DayArray);
MultiLevel.Size = datasize;
end

%Read all data sets from an argus file
function [LevelData]= ArgusReader(Path,StartF,StopF)
 
 len = (StopF-StartF)/0.025;
 fid = fopen(Path);
 jump_distance = 0;
 fseek(fid,jump_distance,'bof');
 LevelData.DeviceId = fread(fid,1,'integer*4=>int32');
 LevelData.Longitude = fread(fid,1,'float=>float');
 LevelData.Latitude = fread(fid,1,'float=>float');
%  jump_distance = 36+0; %+0: min level; +2: mean level; +4: max level
%  fseek(fid,jump_distance,'bof');
%  LevelData.MinLevel = fread(fid,len,'integer*2=>int16',6);
%  jump_distance = 36+2;
%  fseek(fid,jump_distance,'bof');
%  LevelData.MeanLevel= fread(fid,len,'integer*2=>int16',6);
%  jump_distance = 36+4;
 fseek(fid,jump_distance,'bof');
 %LevelData.MaxLevel= fread(fid,len,'integer*2=>int16',6);
 LevelData.Level= fread(fid,len,'integer*2=>int16',6);
 fclose(fid);
end