function monkeybtf=convertbtf2matrix(btffolder)
%% Converts the set of btf files at a location
%% specified by btffolder into a monkeybtf matrix by joining them as seperate columns
currentpos=pwd;
cd(btffolder);
monkeybtf=[];
columnnames={'monkeyid','unixtimestamp','xposition','yposition','zposition','speed','xorientation','yorientation','zorientation','neighbourid'};% Add parameters here if necessary
for i=1:length(columnnames)
monkeybtf(:,i)=dlmread([char(columnnames(i)),'.btf']);
end
cd(currentpos);
end