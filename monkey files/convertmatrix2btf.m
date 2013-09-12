function convertmatrix2btf(monkeybtf,btffolder)
%% Converts the monkeybtf matrix into a set of btf files at a location
%% specified by btffolder

columnnames={'monkeyid','unixtimestamp','xposition','yposition','zposition','speed','xorientation','yorientation','zorientation','neighbourid'};% Add parameters here if necessary
for i=2
dlmwrite([btffolder,'\',char(columnnames(i)),'.btf'],monkeybtf(:,i),'precision',16);
end

end