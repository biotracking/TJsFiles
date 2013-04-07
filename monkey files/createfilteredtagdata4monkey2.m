function createfilteredtagdata4monkey2(tstart,tstop,monkeyid,monkeygroup2tag,framerate,medianfilterorder)
    

% This program applies a median filter on individual intervals of the tag
% data. Linear interpolation is performed next to obtain a final rate of
% framerate samples per second

frameinterval=1/framerate;
tstart=tstart+frameinterval-mod(tstart,frameinterval); %Rounded off to the nearest multiple of frame interval after it
tstop=tstop-mod(tstop,frameinterval); %Rounded off to the nearest multiple of frame interval before it
tscale=tstart:frameinterval:tstop;
monkeybit=false(1,length(tscale));

[p,q]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags. We use the row number given by monkeyid


for i=1:q
    temptagdata=evalin('base',strcat('tag',int2str(monkeygroup2tag(monkeyid,i)))); % In this loop we assign the tags associated with monkeyid given by the monkeyid'th row of monkeygroup2tag one by one to temptagdata 
    tagintervals=getinterpolationintervals(temptagdata,10); % Extract the intervals without breaks greater than a time threshold( 10 seconds)
    for j=1:length(tagintervals)
        t1=temptagdata(tagintervals(j,1),2);t2=temptagdata(tagintervals(j,2),2); % Get the start and end times of the j'th continuous interval and set monkeybit=1 at these frames
        t1=t1+frameinterval-mod(t1,frameinterval);t2=t2-mod(t2,frameinterval);%Rounded off to the nearest multiple of frame interval (nearest multiple after the beginning and before the end)
        t1=max([tstart,t1]);t2=min([tstop,t2]);% If t1 or t2 are out of range then adjust them
        if(t1<tstop)
            it1=find(tscale==t1);it2=find(tscale==t2);
            monkeybit(it1:it2)=true; %After the (for i=1:q) loop monkeybit is set to 1 at indices where atleast one of monkeyid's tags are present
        else
            break;
        end
    end
end
assignin('base',strcat('newmonkey',int2str(monkeyid),'bit'),monkeybit);
[lmonkeybit,num]=bwlabel(monkeybit,8); % Find the continuous regions where atleast one of monkeyid's tags are present
for j=1:q
    
    temptagdata=evalin('base',strcat('tag',int2str(monkeygroup2tag(monkeyid,j)))); 
    newtagdata=[];
    
    for i=1:num % We get num number of continuous periods in time where monkeyid exists
    
        it1=find(lmonkeybit==i);
        it2=tscale(max(it1));%Find the last index of the i'th period
        it1=tscale(min(it1));%Find the first index of the i'th period
        newtime=it1:frameinterval:it2;
        oldindex=temptagdata(:,2);
        % newindexstart and newindexstop are the beginning and ending indices of the i'th continuous set of frames in temptagdata where atleast one tag of monkeyid gives a sample
        % We apply the median filter and interpolate only in these regions
        newindex=abs(oldindex-it1);
        newindexstart=find(newindex==min(newindex),1,'first');
        newindex=abs(oldindex-it2);
        newindexstop=find(newindex==min(newindex),1,'last');
        if(newindexstart<newindexstop)
            temptagdata(newindexstart:newindexstop,3:5)=medfilt1(temptagdata(newindexstart:newindexstop,3:5),medianfilterorder); % Perform median filtering on the ith interval data to remove outliers. This can be replaced in future with a different filter if necessary
            tempx=interp1(temptagdata(:,2),temptagdata(:,3),newtime','linear','extrap'); % Interpolate x-coordinate data
            tempy=interp1(temptagdata(:,2),temptagdata(:,4),newtime','linear','extrap'); % Interpolate y-coordinate data
            tempz=interp1(temptagdata(:,2),temptagdata(:,5),newtime','linear','extrap'); % Interpolate z-coordinate data
        else
            newtime=temptagdata(newindexstart,2)+frameinterval-mod(temptagdata(newindexstart,2),frameinterval);
            tempx=temptagdata(newindexstart,3);
            tempy=temptagdata(newindexstart,4);
            tempz=temptagdata(newindexstart,5);
            
        end
        temp=[temptagdata(1,1)*ones(length(newtime),1),newtime',tempx,tempy,tempz]; 
        newtagdata=[newtagdata;temp];
    end
%     tf=ismember(tscale',newtagdata(:,2));
%     tempindex=find(tf==0);
%     temp=zeros(length(tempindex),5);
%     temp(:,2)=tscale(tempindex);
%     newtagdata=[newtagdata;temp];
%     newtagdata=sortrows(newtagdata,2);
%     tempdiff=diff(newtagdata(:,2));
%     a=mean(tempdiff);
%     a=find(tempdiff<a);
%     a1=a(find(newtagdata(a,1)==0));
%     a2=a(find(newtagdata(a+1,1)==0))+1;
%     newtagdata=removerows(newtagdata,[a1;a2]);
%     tempdiff=diff(newtagdata(:,2));
%     a=find(tempdiff<mean(tempdiff));
%     newtagdata=removerows(newtagdata,a);
    assignin('base',strcat('newtag',int2str(monkeygroup2tag(monkeyid,j)),'data'),newtagdata);
    
end

