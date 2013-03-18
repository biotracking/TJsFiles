function splitfile(filename,numberofdivisions,numberofsamplesperdivision,divisionnameprefix)

%This function is just required to split the data file eg:- 2GB .csv file
%containing monthlong data to smaller, manageable chunks having
%"numberofsamplesperdivision" samples in every chunk.
%It creates csv files prefixed with "divisionnameprefix" in the current
%working folder

for i=0:numberofdivisions-1
% disp(i+1); %This line was just for debugging, to see which file was being created
m=csvread(filename,i*numberofsamplesperdivision,0,[i*numberofsamplesperdivision,0,(i+1)*numberofsamplesperdivision-1,4]);
dlmwrite([divisionnameprefix,int2str(i+1),'.txt'],m,'delimiter',',','precision',16); %csvwrite() doesnt work here. It doesnt have enough precision to store the unix timestamp. 
end