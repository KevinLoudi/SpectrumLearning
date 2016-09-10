%Read Out Spectrum Data from several days (one station)
%Author: Zhu Gengyu
%Date: 2016/7/18
%Path format: 'Y:\\20-3000\\%s\\03' DayArray should be string
%Level.Info: Device, Lon, Lat, Status, FileNum  Level.Data: Time[time,stringlen], level[time,freq]

function [MultiLevel] = MultiDaySpectrumReader(Path,DayArray,StartFreq,StopFreq)
Maxsize = 1000; 
%index for the time slot num
datasize = 1;
%declear Level container
%Level.Info=0;  %Device, Lon, Lat 
Data.time='';
Data.level=0;
Info.DeviceId=0;
Info.Longitude=0;
Info.Latitude=0;
Info.Status=0;
Info.FileNum=0;
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
        [Info,Data]=ArgusReader(filename,StartFreq,StopFreq,Info,Data);
        %tmpLevel.SampleTime=floor(str2num(thisdir(1:12)));
        Data.time(Info.FileNum,1:12)=thisdir(1:12);
        %Count the accessed data
        datasize = datasize + 1;
        index = index + 1;
        if(index > Maxsize)
            %abortion if the data set is too large
            delete Info, Data ;
            break;
        end
     end
  end 
  %Combine the newly read data and existed data in Level
  MultiLevel.ByDay{i}=Data;
end
%presever other information
MultiLevel.Info=Info;
end

%Read all data sets from an argus file
function [Info,Data]=ArgusReader(Path,StartF,StopF,Info,Data)
 
 len = (StopF-StartF)/0.025;
 fid = fopen(Path);
 jump_distance = 0;
 fseek(fid,jump_distance,'bof');
 Info.FileNum=Info.FileNum+1;
 if  Info.Status==0
   Info.DeviceId=fread(fid,1,'integer*4=>int32');
   Info.Longitude= fread(fid,1,'float=>float');
   Info.Latitude=fread(fid,1,'float=>float');
   Info.Status=1; %aleard assign device information
 end

%  jump_distance = 36+0; %+0: min level; +2: mean level; +4: max level
%  fseek(fid,jump_distance,'bof');
%  LevelData.MinLevel = fread(fid,len,'integer*2=>int16',6);
%  jump_distance = 36+2;
%  fseek(fid,jump_distance,'bof');
%  LevelData.MeanLevel= fread(fid,len,'integer*2=>int16',6);
 jump_distance = 36+4;
 fseek(fid,jump_distance,'bof');
 %LevelData.MaxLevel= fread(fid,len,'integer*2=>int16',6);
 Data.level(Info.FileNum, 1:len)= fread(fid,len,'integer*2=>int16',6);
 fclose(fid);
end