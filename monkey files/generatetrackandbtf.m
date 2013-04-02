function generatetrackandbtf(framerate,medianfilterorder,threshold)
% This will act as the master program for generating all the monkey btf
% files.
% Given the data in csv files named as "monthlong - day 1.txt","monthlong - day 2.txt"
% etc present in the working folder we provide the following additional
% parameters - framerate required for the final videos, medianfilterorder
% used when filtering for outliers and threshold i.e distance threshold
% within which 2 monkeys are assumed to be interacting
monkeyradius=0.025;

for i=1:47 % We have 47 files for the monkey data (Change this into an input variable for a generalised function later on)
[m,monkeygroup2tag,tags]=seperateindividualtags(['monthlong - day ',int2str(i),'.txt'],'collar_tags_map_monthlong.txt'); 
tstart=m(1,2);
tstop=m(end,2);
assignin('base','tstart',tstart); % tstart, tstop, m and monkeygroup2tag should be present in the base workspace since the generateallmonkeytracks, findmatrixofinteraction and createbtfsourcedata extarct them from there and not from the generatetrackandbtf's stack.
assignin('base','tstop',tstop);
assignin('base','m',m);
assignin('base','monkeygroup2tag',monkeygroup2tag);
generateallmonkeytracks(tstart,tstop,monkeygroup2tag,framerate,medianfilterorder);
matrixofinteraction=findmatrixofinteraction(monkeygroup2tag,threshold,monkeyradius);
monkeybtf=createbtfsourcedata(monkeygroup2tag);
save(strcat('day',int2str(i),'matrixofinteraction.mat'),'matrixofinteraction'); % Store the generated matrixofinteraction in a .mat file
save(strcat('day',int2str(i),'btf.mat'),'monkeybtf'); % Store the generated monkeybtf in a .mat file
disp(i);
end

end
