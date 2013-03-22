function monkeytrack = combinetags2monkey(tstart,tstop,framerate,monkeyid,monkeygroup2tag)%,newtag1data,newtag2data,newtag3data,newtag4data) 
% We obtain the tags associated with monkeyid from monkeygroup2tag and
% combine these to obtain a single track for each monkey.
% We get tstart and tstop from the original raw combined data. If this
% array is m. Then tstart=m(1,2), tstop=m(length(m),2). These are rounded
% off to the nearest multiple of frame interval


frameinterval=1/framerate;
tstart=tstart+frameinterval-mod(tstart,frameinterval); %Rounded off to the nearest multiple of frame interval after it
tstop=tstop-mod(tstop,frameinterval); %Rounded off to the nearest multiple of frame interval before it
tscale=tstart:frameinterval:tstop;

[m,n]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags
newtagdata=[];

% Combine the data of all tags for convenience

for i=1:n
    temptagdata=evalin('base',strcat('newtag',int2str(monkeygroup2tag(monkeyid,i)),'data')); % In this loop we assign the tags associated with monkeyid given by the monkeyid'th row of monkeygroup2tag one by one to temptagdata 
    newtagdata=[newtagdata;temptagdata]; % We combine all the tags associated with monkeyid in the variable newtagdata.
end

monkeytrack=zeros(length(tscale),5);
index=1;

for i=tstart:frameinterval:tstop
    
    x=find(newtagdata(:,2)==i); % Combining the tags helps us here. In just one instruction, I can search for samples given by different tags at time instant i.
    templength=length(x); % How many tags give me samples at time instant i
    if(isempty(x))
        monkeytrack(index,:)=[0,i,0,0,0]; % Monkey isnt present here. Keep id as 0 and coordinates as [0 0 0] at this time
    else
        for j=1:templength
            monkeytrack(index,3:5)=monkeytrack(index,3:5)+newtagdata(x(j),3:5)/templength; % Coordinates of Monkey are given by the average of the tags that give a sample for that instant.
        end
        monkeytrack(index,1:2)=[monkeyid,i];
    end
    
    index=index+1;
end


 





    
end