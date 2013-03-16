
clear ;

hname=(importdata('humandataname.txt'));
antname=char(unique(hname));
hname=char(hname);
htime=(importdata('humandatatime.txt'));
hstate=(importdata('humandatastate.txt'));
cname=char(importdata('compdataname.txt'));
ctime=(importdata('compdatatime.txt'));
cstate=(importdata('compdatastate.txt'));

slop=10;% We will consdier the events in the range of 2*slop around the current event


clip=input('Enter Clip number:  ');
%clip=1;%Clip number (Change this to see error parameters for different clip numbers)

hnoofevents=find(diff(htime)<0);%number of events recorded by human. Looking at where the difference between adjacent times is negative we can know where a new clip starts
hnoofevents=[0;hnoofevents;length(htime)];
cnoofevents=find(diff(ctime)<0);%number of events recorded by computer
cnoofevents=[0;cnoofevents;length(ctime)];

hname=hname(hnoofevents(clip)+1:hnoofevents(clip+1),:);%ant names recorded by human
hstate=hstate(hnoofevents(clip)+1:hnoofevents(clip+1));%state of ant as recorded by human. Can be - started drinking (SD) or ended drinking (ED)

hstate=char(hstate);
hstate=hstate(:,1);%Discard 'D' from 'SD' and 'ED'
htime=htime(hnoofevents(clip)+1:hnoofevents(clip+1));%timing of events as recorded by human

cname=cname(cnoofevents(clip)+1:cnoofevents(clip+1),:);%ant names recorded by computer
cstate=cstate(cnoofevents(clip)+1:cnoofevents(clip+1));%state of ant as recorded by computer. Can be - started drinking (SD) or ended drinking (ED)
cstate=char(cstate);
cstate=cstate(:,2);
ctime=ctime(cnoofevents(clip)+1:cnoofevents(clip+1));%timing of events as recorded by human
framerate=30;
maxframe=max(max(htime),max(ctime))*framerate+30;
se2 = strel('line',(2*slop+1)*framerate,90);

hframes=zeros(maxframe,length(antname));
cframes=zeros(size(hframes));


for i=1:length(antname)
    temppos=strmatch(antname(i,:),hname, 'exact');
    
    if(~isempty(temppos))
        for j=1:length(temppos)
            if(strcmpi(hstate(temppos(j)),'S'))
                if(j==length(temppos))
                    hframes((htime(temppos(j))+1)*framerate:maxframe,i)=1;
                end
            else
                if(j==1)
                    hframes(1:(htime(temppos(j))+1)*framerate,i)=1;
                else
                    hframes((htime(temppos(j-1))+1)*framerate:(htime(temppos(j))+1)*framerate,i)=1;
                end
            end
        end
    end
    
end

for i=1:length(antname)
    temppos=strmatch(antname(i,:),cname, 'exact');
    
    if(~isempty(temppos))
        for j=1:length(temppos)
            if(strcmpi(cstate(temppos(j)),'S'))
                if(j==length(temppos))
                    cframes((ctime(temppos(j))+1)*framerate:maxframe,i)=1;
                end
            else
                if(j==1)
                    cframes(1:(ctime(temppos(j))+1)*framerate,i)=1;
                else
                    cframes((ctime(temppos(j-1))+1)*framerate:(ctime(temppos(j))+1)*framerate,i)=1;
                end
            end
        end
    end
    
end

hframes2=imdilate(hframes,se2);
totalevents=0;
correctdetect=0;
incorrectdetect=0;

for i=1:length(antname)
    [L, num] = bwlabel(hframes2(:,i));
    for j=1:num
        temppos=find(L==j);
        tempand=hframes2(min(temppos):max(temppos),i)&cframes(min(temppos):max(temppos),i);
        correctdetect=correctdetect+sign(sum(tempand));
    end
    totalevents=totalevents+num;
end

correctdetect=correctdetect/totalevents;
fprintf('True positive rate =');disp(correctdetect);

for i=1:length(antname)
    [L, num] = bwlabel(~hframes2(:,i));
    for j=1:num
        temppos=find(L==j);
        tempand=(~hframes2(min(temppos):max(temppos),i))&cframes(min(temppos):max(temppos),i);
        incorrectdetect=incorrectdetect+sign(sum(tempand));
    end
    totalevents=totalevents+num;
end

incorrectdetect=incorrectdetect/totalevents;
fprintf('False positive rate =');disp(incorrectdetect);
