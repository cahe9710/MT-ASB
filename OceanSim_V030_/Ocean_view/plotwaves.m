function plotwaves(xmin,xmax,ymin,ymax,kvl,padding);


 [X,Y] = meshgrid((xmin-padding):0.5:(xmax+padding),(ymin-padding):0.5:(ymax+padding));

 Z = kvl+rand(size(X))*1.0;

s= surf(X,Y,Z);
set(s,'EdgeColor','none','FaceAlpha',0.2,'FaceColor',[0 0 0.9]);





