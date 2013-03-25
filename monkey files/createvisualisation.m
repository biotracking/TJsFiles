function createvisualisation(monkeybtf,monkeygroup2tag)
    
    [p,q]=size(monkeybtf);
    [m,n]=size(monkeygroup2tag);
    taillength=20;
    monkeyradius=0.025;
    size=3.2;
    xval=([0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]-0.5)*size+size/2;
    yval=([0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]-0.5)*size-0.2+size/2;
    zval=([0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]-0.5)*size+size/2;
    scrsz = get(0,'ScreenSize');
    h=figure('Position',[1 1 scrsz(3) scrsz(4)]);
    mean13=[-0.069,-1.2,-0.049];
    mean15=[-0.340,2.426,-0.271];
    tempmonkeybit=[];
    tempmonkeyposbuffer=zeros(taillength,3);
    
    for i=1:m
        tempmonkeybit=[tempmonkeybit,evalin('base',strcat('monkey',int2str(i),'bit'))];
    end
    
    for i=1:m
        assignin('base',strcat('monkey',int2str(i),'posbuffer'),tempmonkeyposbuffer);
    end
    
    numberofframes=length(tempmonkeybit);
    interactorbcenters=[];
    framenumber=1;
    
    for i=1:p
        scatter3(4,4,4,'w','SizeData',1); hold on;   
        scatter3(-1,-1,0,'w','SizeData',1);
        
        currentmonkey=monkeybtf(i,1);
        if(currentmonkey>0)%monkeyid =0 when theres no monkey in the frame
            evalin('base',strcat('monkey',int2str(currentmonkey),'posbuffer(1:taillength-1,:)=monkey',int2str(currentmonkey),'posbuffer(2:taillength,:);'));%Update buffer to construct tail and show current position
            evalin('base',strcat('monkey',int2str(currentmonkey),'posbuffer(taillength,:)=monkeybtf(i,3:5);'));
            tempposbuffer=evalin('base',strcat('monkey',int2str(currentmonkey),'posbuffer'));
            line(tempposbuffer(1:taillength,1),tempposbuffer(1:taillength,2),tempposbuffer(1:taillength,3),'Color','r','LineWidth',3);%construct tail
            [x,y,z]=ellipsoid(monkeybtf(i,3),monkeybtf(i,4),monkeybtf(i,5),monkeyradius,monkeyradius,monkeyradius,10); 
            plot3(x,y,z,'ro');% construct a sphere for the monkey
            text(tempposbuffer(taillength,1)+0.2,tempposbuffer(taillength,2)+0.2,tempposbuffer(taillength,3)+0.2,strcat('MONKEY ',int2str(currentmonkey)));
            [x,y,z]=cylinder(monkeyradius);
            surf(tempposbuffer(taillength,1)+x,tempposbuffer(taillength,2)+y,tempposbuffer(taillength,3)*z,'FaceColor','r','FaceAlpha',0.4);%show height using a transparent cylinder
            if(monkeybtf(i,10)~=0)
                interactorbcenters=[interactorbcenters;monkeybtf(i,1),monkeybtf(i,10)];
            end
        end
        
        
        % Construct transparent cubical cage in the end
        for j=1:6
            g=patch(xval(:,j),yval(:,j),zval(:,j),'w','FaceColor','b','FaceAlpha',0.1);
            set(g,'edgecolor','k')
        end
        
        if((monkeybtf(i+1,2)~=monkeybtf(i,2))&&i<p)
            % Draw the interaction orbs here
            for j=1:length(interactorbcenters)
                center1=evalin('base',strcat('monkey',int2str(interactorbcenters(j,1)),'posbuffer(taillength,:)'));
                center2=evalin('base',strcat('monkey',int2str(interactorbcenters(j,2)),'posbuffer(taillength,:)'));
                center=(center1+center2)*0.5;
                distance=sum((center1-center2).^2).^0.5;
                [x,y,z]=ellipsoid(center(1),center(2),center(3),distance,distance,distance,10);
                surf(x,y,z,'FaceColor','k','FaceAlpha',0.2,'EdgeColor','none');
            end
            interactorbcenters=[];
            [x,y,z]=cylinder(0.02);
            surf(x+mean13(1),y+mean13(2),z*4+mean13(3));
            surf(x+mean15(1),y+mean15(2),z*4+mean15(3));
            camorbit(15,15);
            
            drawnow;
            framenumber=framenumber+1;
            hold off;
        end
        
    end
    
    

end