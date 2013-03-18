function [m,monkeygroup2tag,tags]=seperateindividualtags(datafilename,tag2monkeymappingfilename)
% -Use this after splitting the original 2GB file into smaller chunks. These
%  smaller chunks give the datafilename inputs.

% -tag2monkeymappingfilename gives the name of the file containing the
%  tagnumbers in one column and the respective monkey number in the second
%  column. One of the groups should contain only 2 tags. These will be the
%  stationary tags

% -This function seperates the individual tags from the data file into
%  seperate variable in the workspace with names tag1, tag2, ...

% -It also returns the original combined form data as variable m
tagid=csvread(tag2monkeymappingfilename); %First column will have the tag numbers and second column will have the monkey number
tags=tagid(:,1); %Get the tag numbers
m=csvread(datafilename); % load the required csv data file
noofmonkeys=max(tagid(:,2))-1; % Monkey numbers start from 1 and are consecutive integers. The last number is reserved for stationary tags so we need to subtract one.
nooftagspermonkey=length(find(tagid(:,2)==1)); % find the number of tags correspond to a single monkey. In this case monkey 1. (Assume all monkeys have same number of tags)
monkeygroup2tag=zeros(noofmonkeys,nooftagspermonkey);

for i=1:noofmonkeys
    monkeygroup2tag(i,:)=find(tagid(:,2)==i); %Create a 2d array where the i'th row contains the tag numbers for the i'th monkey
end

for i=1:length(tags) %seperate tag data
temp=m(m(:,1)==tags(i),:); %Find the samples in combined data m having tag number (column 1) equal to i th element of array tags
assignin('base',strcat('tag',int2str(i)),temp);  % Create a variable in the workspace called tagi 
end
