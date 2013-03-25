for i=1:47
    disp(i);
    m=csvread(['monthlong - day ',int2str(i),'.txt']);
    x=find(max(m(:,3:5),[],2)>3.2);
    y=find(min(m(:,3:5),[],2)<-0.5);
    c=union(x,y);
    errorsonday(i)=length(c);
end    
  
    