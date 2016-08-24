%Read Spectrum Data from a signal day
%Author: Zhu Gengyu
%Data: 2016/7/11

function [Level]=SpectrumReader(Path, StartF, StopF, StepF)
 SelItem1 = (StartF-2010)/StepF+1;
 SelItem2 = (StopF-2010)/StepF+1;
 %Get all Filenames belongs to a specific station 
 dirinfo = dir(Path);
 %AbsoPath = [Path,'\\%s']; %strcat
 %Loop for all File
 index = 1;
 for k = 1:length(dirinfo)
    thisdir = dirinfo(k).name;
    %Concate the two path
    %Filename = Path + '\'+ thisdir; %sprintf(AbsoPath,thisdir); 
    Filename = [Path,'\',thisdir];
    if exist(Filename,'file') == 2 
        %Test: if the filepath is accessible
        tmpLevel = ArgusReader(Filename,2010,2150);
        Level{index} = tmpLevel;
        index = index + 1;
    end
 end
end

%Read all data sets from an argus file
function [LevelData]= ArgusReader(Path,StartF,StopF)
 jump_distance = 36+0; 
 len = (StopF-StartF)/0.025;
 fid = fopen(Path);
 fseek(fid,jump_distance,'bof');
 LevelData = fread(fid,len,'integer*2=>int16',6);
 fclose(fid);
end