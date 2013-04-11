function writegmlfile(matrixofinteraction,filename)
% This function is used to write the .gml files that can be read by Gephi (graph creation software)
% It has a format as given below - 
%
%graph[
%node[
%id 0
%label "label"
%parameter1 "parameter1"
%parameter2 "parameter2"
%]
%.
%.
%.
%edge[
%id 0
%source sourcenodeid
%target targetnodeid
%value weight
%]
%.
%.
%.
%]
%
%
%The weights of the edges are derived from the matrixofinteraction
%
%
[m,n]=size(matrixofinteraction);
writethis=[];
writethis=strvcat(writethis,'graph','[');
id=0;
for i=1:m
    writethis=strvcat(writethis,'node','[',['id ',int2str(id)],['label "Monkey ',int2str(i),'"'],'sex "male"',['age "',int2str(randint(1,1,[0,3])),'"'],']');
    id=id+1;
end

id=0;
for i=1:m-1
    for j=i+1:m
        writethis=strvcat(writethis,'edge','[',['id ',int2str(id)],['source ',int2str(i-1)],['target ',int2str(j-1)],['value ',num2str(matrixofinteraction(i,j))],']');
        id=id+1;
    end
    
end
writethis=strvcat(writethis,']');
dlmwrite(filename,writethis,'');
%'day',int2str(day),'edges.txt'
