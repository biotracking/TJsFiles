function [newtime,newname,xdata,ydata]= convertantcsv2btf(csvfilename,timebtf,namebtf,xbtf,ybtf)
%Inputs are
%csvfilename - string indicating input csv file name eg:- filtered1
%timebtf,namebtf,xbtf,ybtf - strings indicating names of required output btf files for time,name,xdata and ydata
%eg:- [newtime,newname,xdata,ydata]= convertantcsv2btf('filtered1','time','name','xdata','ydata');
% This takes input filtered1.csv and creates files time.btf, name.btf,
% xdata.btf, ydata.btf as output in the current working directory
% newtime,newname,xdata,ydata are variables in the workspace that store the
% same data.

A = importdata([csvfilename,'.csv'], ',',1); % import the csv file as a cell array (The first row is the column headers so we truncate it in the next 2 lines) 
time=A.textdata(2:end,1); % Array storing frame number. We get a cell array that we cant use directly as numbers
name=A.textdata(2:end,3); % Array storing ant name
antnames=char(unique(name));%Find the ants that are in this csv file
antid=num2cell(1:length(antnames))';%Attach a number to each of the ants. Number corresponds to the row at which the name is present in array "antnames"
xdata=[];% x coordinate data to display the ant name
ydata=[];% y coordinate data to display the ant name 
newtime=[];
newname=[];

for i=1:length(name)    %Construct the array "id" to store the ant ids instead of names. This makes it easier to compare strings later and update the y coordinate            
    for j=1:length(antnames)
        if(antnames(j,:)==char(name(i)))
            id(i,1)=j;
            break;
        end
    end
end

for i=1:length(time)    %Convert cell array "time" to numeric array "temp"
    temp(i,1)=str2num(cell2mat(time(i,1)));
end
time=temp;
tmax=max(time);
 tmin=min(time); % Use tmin=1 if needed

for i=tmin:tmax 
    m=find(time==i);
    if(~isempty(m))
        ants_at_time_m=unique(id(m)); % remove all redundancies at a particular time (multiple occurances of same ant) 
        newtime=[newtime;i*ones(length(ants_at_time_m),1)];
        newname=[newname;antnames(ants_at_time_m,:)];
        ydata=[ydata;20*ants_at_time_m];
        xdata=[xdata;10*ones(length(ants_at_time_m),1)];% x coordinate data to display the ant name remains constant
    end
        
end

% Save variables as btf files
dlmwrite([timebtf,'.btf'],newtime);
dlmwrite([namebtf,'.btf'],newname,'delimiter','');
dlmwrite([xbtf,'.btf'],xdata);
dlmwrite([ybtf,'.btf'],ydata);

end