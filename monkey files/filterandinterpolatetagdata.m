function [newtagdata,tagdata]=filterandinterpolatetagdata(tagdata,tagintervals,framerate,medianfilterorder)
    
%Use this function after getting the tag intervals
% This program applies a median filter on individual intervals of the tag
% data. Linear interpolation is performed next to obtain a final rate of
% framerate samples per second

    newtagdata=[];
    m=length(tagintervals);
    
    for  i=1:m
        istart=tagintervals(i,1);
        istop=tagintervals(i,2);
        if(istart<istop)
            tagdata(istart:istop,3:5)=medfilt1(tagdata(istart:istop,3:5),medianfilterorder);
            tstart=tagdata(istart,2);tstart=tstart+1/framerate-mod(tstart,1/framerate);
            tstop=tagdata(istop,2);tstop=tstop-mod(tstop,1/framerate); %Will this go lower than start?
            newtime=tstart:1/framerate:tstop;newtime=newtime';
            tempx=interp1(tagdata(istart:istop,2),tagdata(istart:istop,3),newtime);
            tempy=interp1(tagdata(istart:istop,2),tagdata(istart:istop,4),newtime);
            tempz=interp1(tagdata(istart:istop,2),tagdata(istart:istop,5),newtime);
        elseif(istart==istop)
            newtime=tagdata(istart,2)+1/framerate-mod(tagdata(istart,2),1/framerate);
            tempx=tagdata(istart,3);
            tempy=tagdata(istart,4);
            tempz=tagdata(istart,5);
        end
        temp=[tagdata(1,1)*ones(length(newtime),1),newtime,tempx,tempy,tempz];
        newtagdata=[newtagdata;temp];
    end
    
    
end