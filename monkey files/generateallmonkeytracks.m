function generateallmonkeytracks(tstart,tstop,monkeygroup2tag,framerate,medianfilterorder) 
% Use this function after seperateindividualtags.m to get all monkeytrack variables
[m,n]=size(monkeygroup2tag);
for i=1:m
    createfilteredtagdata4monkey2(tstart,tstop,i,monkeygroup2tag,framerate,medianfilterorder);%createfilteredtagdata4monkey(i,monkeygroup2tag,framerate,medianfilterorder);
    evalin('base',strcat('[monkey',int2str(i),'track,monkey',int2str(i),'speed,monkey',int2str(i),'orientation,monkey',int2str(i),'bit]=combinetags2monkey(tstart,tstop,framerate,',int2str(i),',monkeygroup2tag);'));
end
end