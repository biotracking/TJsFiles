function [dat,n]=generateheatmap(monkeyid,monkeybtf,noofhistogrambinsx,noofhistogrambinsy,cagemin,cagemax)
% Program to generate a heat map that shows the frequency of visiting a
% particular region in the cage
%noofhistogrambinsx = number of bins used in calculating the histogram for x axis
%noofhistogrambinsy = number of bins used in calculating the histogram for y axis
%cagemin = minimum value of cage coordinates in any direction (assuming the cage is a cube) 
%cagemax = maximum value of cage coordinates in any direction
%We calculate the histogram only over the range [cagemin,cagemax] 
figure;
dat=monkeybtf(find(monkeybtf(:,1)==monkeyid),3:4);
n = hist3(dat,[noofhistogrambinsx,noofhistogrambinsy]); % Extract histogram data;
% Divide the cage area into a noofhistogrambinsx by noofhistogrambinsy
% matrix and calculate the histogram of monkeyid's position
n1 = n';
n1( size(n,1) + 1 ,size(n,2) + 1 ) = 0;
% Generate grid for 2-D projected view of intensities
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1)+1);
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1)+1);
% Make a pseudocolor plot on this grid
h = pcolor(xb,yb,n1);
% Set the z-level and colormap of the displayed grid
colormap(hot) % heat map
title('Intensity Map');
xlabel('X-Axis');
ylabel('Y-Axis');
%-- 1/4/13  6:42 PM --%
end