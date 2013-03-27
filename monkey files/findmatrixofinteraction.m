function matrixofinteraction=findmatrixofinteraction(monkeygroup2tag,threshold)

% threshold - sets the distance threshold. If distance between any two
% monkeys is less than this value then they are considered to be
% interacting. This program will also create a set of column vectors
% monkeykinteractingwith wich indicates the monkeyid with which monkey k
% might be interacting with. (They are both within a certain distance given by "threshold")

[m,n]=size(monkeygroup2tag); % m gives the number of monkeys and n gives the number of tags. 
matrixofinteraction=zeros(m); % Stores tie strength as the number of frames of interaction between any 2 monkeys in a data file

tempmonkey1bit=evalin('base',strcat('monkey',int2str(1),'bit')); % Given the boolean array which indicates whether monkey i is present in a frame
tempmonkeyiinteractingwith=zeros(size(tempmonkey1bit));

for k=1:m % in this loop we will create a set of variables named "monkeykinteractingwith". the i'th index of this array will give us which monkey the k'th monkey is interacting with in a particular frame
    assignin('base',strcat('monkey',int2str(k),'interactingwith'),tempmonkeyiinteractingwith);
end


for i=1:m-1
    tempmonkeyibit=evalin('base',strcat('monkey',int2str(i),'bit')); % Given the boolean array which indicates whether monkey i is present in a frame
    tempmonkeyiinteractingwith=evalin('base',strcat('monkey',int2str(i),'interactingwith')); 
    
    for j=m:-1:i+1
        tempmonkeyjbit=evalin('base',strcat('monkey',int2str(j),'bit')); % Given the boolean array which indicates whether monkey j is present in a frame
        tempbothpresent=tempmonkeyibit&tempmonkeyjbit;  % Given the boolean array which indicates whether both monkey i and monkey j are present in a frame
        x=find(tempbothpresent==1); % Finds the indices where both monkeys are present
        tempmonkeyitrack=evalin('base',strcat('monkey',int2str(i),'track(:,3:5)')); % Get the position coordinates at these indices for monkey i
        tempmonkeyitrack=tempmonkeyitrack(x,:);
        tempmonkeyjtrack=evalin('base',strcat('monkey',int2str(j),'track(:,3:5)')); % Get the position coordinates at these indices for monkey j
        tempmonkeyjtrack=tempmonkeyjtrack(x,:);
        tempdist=sum((tempmonkeyitrack'-tempmonkeyjtrack').^2)'; % Get the euclidean distance between these two monkeys at time frames given by x
        y=find(tempdist<threshold); % Find the indices where the distance between the two monkeys is less than the distance threshold.
        matrixofinteraction(i,j)=matrixofinteraction(i,j)+length(y); % add the number of frames where monkey i and monkey j are interacting to the (i,j) th element of [matrixofinteraction]
        matrixofinteraction(j,i)=matrixofinteraction(i,j);
        
        tempmonkeyjinteractingwith=evalin('base',strcat('monkey',int2str(j),'interactingwith')); 
        tempmonkeyiinteractingwith(x(y))=j; % indicate that the ith monkey is interacting with monkeyid=j at the frames given by indexes x(y)
        tempmonkeyjinteractingwith(x(y))=i; % similarly indicate that the jth monkey is interacting with monkeyid=i at the frames given by indexes x(y)
        
        assignin('base',strcat('monkey',int2str(i),'interactingwith'),tempmonkeyiinteractingwith);
        assignin('base',strcat('monkey',int2str(j),'interactingwith'),tempmonkeyjinteractingwith);
        
    end
end

 