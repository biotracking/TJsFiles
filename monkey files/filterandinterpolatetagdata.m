function [newtagdata,tagdata]=filterandinterpolatetagdata(tagdata,tagintervals,framerate,medianfilterorder)
    
%Use this function after getting the tag intervals
% This program applies a median filter on individual intervals of the tag
% data. Linear interpolation is performed next to obtain a final rate of
% framerate samples per second

    newtagdata=[]; % This array will contain the tag data after filtering and interpolation
    m=length(tagintervals); % Number of detected intervals = Number of rows of array "tagintervals"
    
    for  i=1:m
        istart=tagintervals(i,1);  % Get the index of the start of i'th interval
        istop=tagintervals(i,2);   % Get the index of the end of i'th interval
        if(istart<istop)    % If the start and stop indexes arent the same
            % Remove outliers using median filter
            tagdata(istart:istop,3:5)=medfilt1(tagdata(istart:istop,3:5),medianfilterorder); % Perform median filtering on the ith interval data to remove outliers. This can be replaced in future with a different filter if necessary
            tstart=tagdata(istart,2);tstart=tstart+1/framerate-mod(tstart,1/framerate); % Find the actual time at the index istart. Round it off to the nearest multiple of frame interval greater than itself
            tstop=tagdata(istop,2);tstop=tstop-mod(tstop,1/framerate); % Find the actual time at the index istop. Round it off to the nearest multiple of frame interval greater than itself %Will this go lower than start?
            newtime=tstart:1/framerate:tstop;newtime=newtime'; % Create an array for the new time scale starting at tstart and ending at tstop
            tempx=interp1(tagdata(istart:istop,2),tagdata(istart:istop,3),newtime,'linear','extrap'); % Interpolate x-coordinate data
            tempy=interp1(tagdata(istart:istop,2),tagdata(istart:istop,4),newtime,'linear','extrap'); % Interpolate y-coordinate data
            tempz=interp1(tagdata(istart:istop,2),tagdata(istart:istop,5),newtime,'linear','extrap'); % Interpolate z-coordinate data
        elseif(istart==istop) % If the start and stop indexes are the same
            newtime=tagdata(istart,2)+1/framerate-mod(tagdata(istart,2),1/framerate);
            tempx=tagdata(istart,3);
            tempy=tagdata(istart,4);
            tempz=tagdata(istart,5);
        end
        temp=[tagdata(1,1)*ones(length(newtime),1),newtime,tempx,tempy,tempz]; 
        newtagdata=[newtagdata;temp]; % Append the filtered and interpolated ith interval to newtagdata
    end
    
    
end