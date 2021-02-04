function plot_Boat(x_,y_,yaw_)

tmp   = axis;
scale = 1*sqrt((tmp(2)-tmp(1))^2+(tmp(4)-tmp(3))^2);

N =length(x_);
for ii=1:round(N/30):N
    plotB(x_(ii),y_(ii),yaw_(ii),scale);
end


function plotB(x,y,yaw,scale)
  
    xy=[500 0
        100 0
      50 30
      -100 30
      -100 -30 
       50 -30
      100 0
      -100 0]'*scale/200/20;
  
  T = [ cos(yaw)  -sin(yaw);
       sin(yaw)  cos(yaw)];

  xy = T*xy+ [x;y];

  plot(xy(2,:),xy(1,:),'k');
end
end
