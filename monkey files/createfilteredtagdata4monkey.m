function createfilteredtagdata4monkey(monkeyid,monkeygroup2tag,framerate,medianfilterorder)
% This function uses filterandinterpolatetagdata and getinterpolationintervals functions to generate the
% filtered tags associated with monkeyid


[m,n]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags. We use the row number given by monkeyid


for i=1:n
    temptagdata=evalin('base',strcat('tag',int2str(monkeygroup2tag(monkeyid,i)))); % In this loop we assign the tags associated with monkeyid given by the monkeyid'th row of monkeygroup2tag one by one to temptagdata 
    tagintervals=getinterpolationintervals(temptagdata); % Extract the intervals without breaks
    [newtagdata,tagdata]=filterandinterpolatetagdata(tagdata,tagintervals,framerate,medianfilterorder); % filter and interpolate within these intervals
    assignin('base',strcat('newtag',int2str(monkeygroup2tag(monkeyid,i))),newtagdata);  % Create a variable in the workspace called newtagidata giving filtered and interpolated data associated with the i'th tag of monkeyid 
end