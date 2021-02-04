function [truth] = integrate(dt,truth,acc)

Vx         = truth.Vx + (truth.acc(1)+acc(1))*0.5*dt;
Vy         = truth.Vy + (truth.acc(2)+acc(2))*0.5*dt;
Rx         = truth.Rx + (truth.acc(3)+acc(3))*0.5*dt;
Rz         = truth.Rz + (truth.acc(4)+acc(4))*0.5*dt;
truth.roll = truth.roll + (truth.Rx+Rx)*0.5*dt;
truth.yaw  = truth.yaw  + (truth.Rz+Rz)*0.5*dt;
truth.x    = truth.x + ((truth.Vx*cos(truth.yaw)-truth.Vy*sin(truth.yaw))+(Vx*cos(truth.yaw)-Vy*sin(truth.yaw)))*0.5*dt;
truth.y    = truth.y + ((truth.Vx*sin(truth.yaw)+truth.Vy*cos(truth.yaw))+(Vx*sin(truth.yaw)+Vy*cos(truth.yaw)))*0.5*dt;
truth.Vx   = Vx;
truth.Vy   = Vy;
truth.Rx   = Rx;
truth.Rz   = Rz;
truth.acc  = acc;
truth.time = truth.time+dt;
