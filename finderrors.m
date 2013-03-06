
% load('findingerrors.mat');
clear;
hname=char(importdata('humandataname.txt'));
htime=(importdata('humandatatime.txt'));
hstate=(importdata('humandatastate.txt'));
cname=char(importdata('compdataname.txt'));
ctime=(importdata('compdatatime.txt'));
cstate=(importdata('compdatastate.txt'));

twindow=40;
clip=3;

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

falseneg=0;
falsepos=0;


% PART 1

% loop to calculate false positive error (incorrectly detected events)

for i=1:(cnoofevents(clip+1)-cnoofevents(clip))
    
    t_error=twindow;
    tmin=ctime(i)-twindow;
    tmax=ctime(i)+twindow;
    temp=find(htime<tmax);
    temp2=find(htime>tmin);
    temp=intersect(temp2,temp);%indexes where htime belongs to the range ctime-5 and ctime+5
    flag=0;
    if(~isempty(temp))
        for j=1:length(temp)
            if(strcmp(hstate(temp(j)),cstate(i))&&strcmp(hname(temp(j),:),cname(i,:))) % find an event where the ant name state recorded by the computer matches that recorded by the human
                flag=1;
                if(abs(htime(temp(j))-ctime(i))<t_error)%Find time difference between closest similar event
                    t_error=abs(htime(temp(j))-ctime(i));%make terror an accumulator if looking for average error
                end
            end
        end
    end
    if(flag==0)
        falsepos=falsepos+1;
    end
    
end    

% loop to calculate false negative error (incorrectly missed events)

for i=1:(hnoofevents(clip+1)-hnoofevents(clip))
    
    t_error=twindow;
    tmin=htime(i)-twindow;
    tmax=htime(i)+twindow;
    temp=find(ctime<tmax);
    temp2=find(ctime>tmin);
    temp=intersect(temp2,temp);%indexes where htime belongs to the range ctime-5 and ctime+5
    flag=0;
    if(~isempty(temp))
        for j=1:length(temp)
            if(strcmp(cstate(temp(j)),hstate(i))&&strcmp(cname(temp(j),:),hname(i,:))) % find an event where the human name state recorded by the human matches that recorded by the computer
                flag=1;
                if(abs(ctime(temp(j))-htime(i))<t_error)
                    t_error=abs(ctime(temp(j))-htime(i));
                end
            end
        end
    end
    if(flag==0)
        falseneg=falseneg+1;
    end
    
end    

%PART 2

% loop to calculate average hamming distance for unsorted strings (not considering presence of anagrams)
flag=0;

for i=1:(cnoofevents(clip+1)-cnoofevents(clip))
    
    
    tmin=ctime(i)-twindow;
    tmax=ctime(i)+twindow;
    temp=find(htime<tmax);
    temp2=find(htime>tmin);
    temp=intersect(temp2,temp);%indexes where htime belongs to the range ctime-5 and ctime+5

    if(~isempty(temp))
        flag=flag+1;
        hamming_error_unsorted(flag)=4;%maximum hamming distance for strings of length 4
        for j=1:length(temp)
            if(strcmp(hstate(temp(j)),cstate(i))) % find an event where the ant name state recorded by the computer matches that recorded by the human
                if(sum(hname(temp(j),:)~=cname(i,:))<hamming_error_unsorted(flag))%Find time difference between closest similar event
                    hamming_error_unsorted(flag)=sum(hname(temp(j),:)~=cname(i,:));
                end
            end
        end


    end
    

end    
hammingdist_avg_unsorted=mean(hamming_error_unsorted);
hammingdist_var_unsorted=var(hamming_error_unsorted);


%PART 3
% loop to calculate average hamming distance for sorted strings (considering presence of anagrams)
flag=0;

for i=1:(cnoofevents(clip+1)-cnoofevents(clip))
    
    
    tmin=ctime(i)-twindow;
    tmax=ctime(i)+twindow;
    temp=find(htime<tmax);
    temp2=find(htime>tmin);
    temp=intersect(temp2,temp);%indexes where htime belongs to the range ctime-5 and ctime+5

    if(~isempty(temp))
        flag=flag+1;
        hamming_error_sorted(flag)=4;%maximum hamming distance for strings of length 4
        tempname1=sort(cname(i,:));
        for j=1:length(temp)
            tempname2=sort(hname(temp(j),:));
            if(strcmp(hstate(temp(j)),cstate(i))) % find an event where the ant name state recorded by the computer matches that recorded by the human
                if(sum(tempname1~=tempname2)<hamming_error_sorted(flag))%Find time difference between closest similar event
                    hamming_error_sorted(flag)=sum(tempname1~=tempname2);
                end
            end
        end


    end
    

end    
hammingdist_avg_sorted=mean(hamming_error_sorted);
hammingdist_var_sorted=var(hamming_error_sorted);


