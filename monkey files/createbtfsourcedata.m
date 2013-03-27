function monkeybtf=createbtfsourcedata(monkeygroup2tag)
%This function takes the tracks for all the monkeys generated using the
%function combinetags2monkey.m and combines to generate a combined data
%file where we can have multiple rows for a single time instant indicating
%the presence of more than one monkey at that time instant. This will make
%it more conducive for conversion to btf format. The output variable can be
%split into the required btf files

[m,n]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags. We use the row number given by monkeyid
tempmonkeybtf=[]; 
tempmonkeybit=[];

for i=1:m
    tempmonkeybit=[tempmonkeybit,evalin('base',strcat('monkey',int2str(i),'bit'))];
end

tempmonkeybit=sum(tempmonkeybit,2);%Sum the rows. The final array will have a value greater than zero if any monkey is present in that frame
x=find(tempmonkeybit>0);%monkeys are present at these indices

for i=1:m
    tempmonkeytrack=evalin('base',strcat('monkey',int2str(i),'track'));
    tempmonkeyorientation=evalin('base',strcat('monkey',int2str(i),'orientation'));
    tempmonkeyspeed=evalin('base',strcat('monkey',int2str(i),'speed'));
    tempmonkeyinteractingwith=evalin('base',strcat('monkey',int2str(i),'interactingwith'));
    tempmonkeycombo=[tempmonkeytrack,tempmonkeyspeed,tempmonkeyorientation,tempmonkeyinteractingwith];% Combine all monkey track data including velocity and orientation for convenience. If this is done we can just sort the matrix to obtain btf format style data.
    y=find(tempmonkeycombo(:,1)==0);
    monkeypresentbutid0=intersect(x,y);%monkey i isnt present at this instant but some other monkey is present. We remove these rows. (Else we get multiple rows with id 0 even when monkeys are present)
    tempmonkeycombo=removerows(tempmonkeycombo,monkeypresentbutid0);
    tempmonkeybtf=[tempmonkeybtf;tempmonkeycombo];
end
%Need to remove samples with monkeyid = 0 when monkeys are present
tempmonkeybtf=unique(tempmonkeybtf,'rows'); % Remove the redundant rows. Mostly caused by the presence of extra rows with id 0 at the same instant where no monkeys are present
monkeybtf=sortrows(tempmonkeybtf,2); %Sort the combined monkey track data rows by time (column 2). 

