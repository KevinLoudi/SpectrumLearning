%Implementation of BP-ANN in analysis
%Author: Zhu Gengyu
%Date: 2016/9/17

function BP_ANN_Forecast()
    load DayChannelState.csv;
    OrigData=DayChannelState;
    clear DayChannelState;
    %randomly select a channel
    SelData=OrigData(135, :);
    T=length(SelData); tao=4;
    rowsz=tao; colsz=T-tao;
    %input data-set matrix
    data=zeros(rowsz,colsz); 
    for i=1:colsz
        for j=1:rowsz
            data(i,j)=SelData(tao-j+i);
        end
    end
    
    %output data-set matrix
    oudata=zeros(T-tao-1,1);
    oudata=SelData(tao+1:T);
    
    %BP-ANN
    net=newff(data,oudata,20);
    net=train(net,data,oudata);
    outputs=net(data);
    errors=outputs-oudata;
    perf=perform(net,outputs,oudata);

end