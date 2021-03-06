function [monkeytrack,monkeyspeed,monkeyorientation,monkeybit] = combinetags2monkey(tstart,tstop,framerate,monkeyid,monkeygroup2tag)
% We obtain the tags associated with monkeyid from monkeygroup2tag and
% combine these to obtain a single track for each monkey.
% We get tstart and tstop from the original raw combined data. If this
% array is m. Then tstart=m(1,2), tstop=m(length(m),2). These are rounded
% off to the nearest multiple of frame interval. monkeybit is a logical
% array. If the ith index is 1 it indicates the presence of the monkey at
% that index of time. monkeyvelocity can be used to obtainthe speed and
% orientation of the monkey assuming that the monkeys dont usually walk backwards 


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

if(~isempty(newtagdata))% If the tag wasnt present in that time interval we get an empty variable []
    newtagdata=sortrows(newtagdata,2);
end

monkeybit=false(length(tscale),1);
monkeytrack=zeros(length(tscale),5);
index=1;

for i=tstart:frameinterval:tstop
    
    if(~isempty(newtagdata))
        x=find(newtagdata(:,2)==i); % Combining the tags helps us here. In just one instruction, I can search for samples given by different tags at time instant i.
        y=find(newtagdata(x,1)>0);
        templength=length(y); % How many tags give me samples at time instant i
    else
        templength=0;
    end
    
    if(templength==0)
        monkeytrack(index,:)=[0,i,0,0,0]; % Monkey isnt present here. Keep id as 0 and coordinates as [0 0 0] at this time
    else
        for j=1:templength
            monkeytrack(index,3:5)=monkeytrack(index,3:5)+newtagdata(x(j),3:5)/templength; % Coordinates of Monkey are given by the average of the tags that give a sample for that instant.
        end
        monkeytrack(index,1:2)=[monkeyid,i];
        monkeybit(index)=true;
    end
    
    index=index+1;
end
newmonkeybit=evalin('base',strcat('newmonkey',int2str(monkeyid),'bit'));% After combining we will find many frames with no sample even when in the earlier stage this wasnt the case. This causes the monkey to appear to flicker in and out of existence.
a=xor(newmonkeybit',monkeybit);% Gives the samples that are actually present (indicated by newmonkeybit) but missing after combining into a single track (indicated by monkeybit)
x=find(a==1);
newtime=tscale(x);
monkeytrack=removerows(monkeytrack,x);% Remove the frames at these times. (These will be frames of type [0 time 0 0 0]). Will return the same values if still present for interpolation.
% We fill by interpolation these missing samples at times indicated by newtime 
tempx=interp1(monkeytrack(:,2),monkeytrack(:,3),newtime,'linear','extrap'); % Interpolate x-coordinate data.  
tempy=interp1(monkeytrack(:,2),monkeytrack(:,4),newtime,'linear','extrap'); % Interpolate y-coordinate data
tempz=interp1(monkeytrack(:,2),monkeytrack(:,5),newtime,'linear','extrap'); % Interpolate z-coordinate data
monkeytrack=[monkeytrack;ones(length(newtime),1)*monkeyid,newtime',tempx',tempy',tempz'];% Append these interpolated values 
monkeytrack=sortrows(monkeytrack,2);% and then sort the matrix by time axis

monkeybit=newmonkeybit';
monkeyvelocity=diff(monkeytrack(:,3:5))*framerate; % The velocity is given by the difference in position between adjacent frames divided by frame interval.
monkeyvelocity=[0 0 0; monkeyvelocity];% Add initial velocity zero
monkeyvelocity=monkeyvelocity.*[monkeybit,monkeybit,monkeybit];%Make velocity = 0 when monkey isnt present
monkeyvelocity=monkeyvelocity(2:length(monkeyvelocity),:);
monkeyspeed=sum((monkeyvelocity)'.^2)'.^0.5;
monkeyorientationx=[0; acosd(monkeyvelocity(:,1)./monkeyspeed)];% Orientation wrt x axis (in degrees). The initial value is kept zero
x= isnan(monkeyorientationx);monkeyorientationx(x)=0; % Speed was zero here so monkeyvelocity(:,1)./monkeyspeed = 0/0 = NaN
monkeyorientationy=[0; acosd(monkeyvelocity(:,2)./monkeyspeed)];% Orientation wrt y axis (in degrees). The initial value is kept zero
x= isnan(monkeyorientationy);monkeyorientationy(x)=0;
monkeyorientationz=[0; acosd(monkeyvelocity(:,3)./monkeyspeed)];% Orientation wrt z axis (in degrees). The initial value is kept zero
x= isnan(monkeyorientationz);monkeyorientationz(x)=0;
monkeyorientation=[monkeyorientationx,monkeyorientationy,monkeyorientationz];% Combine orientations into a single array
monkeyspeed=[0;monkeyspeed];
monkeyvelocity=[0 0 0; monkeyvelocity];% Add initial velocity zero


    
end