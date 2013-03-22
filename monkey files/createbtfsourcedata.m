function monkeybtf=createbtfsourcedata(monkeygroup2tag)
%This function takes the tracks for all the monkeys generated using the
%function combinetags2monkey.m and combines to generate a combined data
%file where we can have multiple rows for a single time instant indicating
%the presence of more than one monkey at that time instant. This will make
%it more conducive for conversion to btf format. The output variable can be
%split into the required btf files

[m,n]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags. We use the row number given by monkeyid
tempmonkeybtf=[]; 

for i=1:m
    tempmonkeytrack=evalin('base',strcat('monkey',int2str(i),'track'));
    tempmonkeybtf=[tempmonkeybtf;tempmonkeytrack];% Combine all monkey track data for convenience. If this is done we can just sort the matrix to obtain btf format style data.
end
tempmonkeybtf=unique(tempmonkeybtf,'rows'); % Remove the redundant rows. Mostly caused by the presence of extra rows with id 0 at the same instant where no monkeys are present
monkeybtf=sortrows(tempmonkeybtf,2); %Sort the combined monkey track data rows by time (column 2). 

