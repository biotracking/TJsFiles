function tagintervals=getinterpolationintervals(tagdata)
% Use this function after getting individual tag data.
% The tag data has a lot of breaks. (If the monkeys are taken out and put back in after a day, this will give a huge break)
% To apply a filter to the position data we need to identify the intervals over which we can perform an operation 
% The output variable tagintervals is a 2d array such that the i'th row has the
% start time in column 1 and end time in column 2 for an interval without breaks. 

tdiff=diff(tagdata(:,2)); % Get the differential of the time data (2nd column of the tag data) 
x=find(tdiff>10); % If the difference between two consecutive samples is more than 10 seconds then take that to be a break
x=[0;x;length(tagdata)]; % Append the array with the index for final tag time and prepend with a 0 (so that the start of the first interval is at the first time index and end of the last interval is at the final time index)
tagintervals=zeros(length(x)-1,2);
for i=1:length(x)-1
tagintervals(i,:)=[x(i)+1,x(i+1)];
end