function V = attitudes(V,yaw,roll,pitch);
        
        
T_x = [  1    0           0;
         0  cos(roll) sin(roll);
         0  -sin(roll) cos(roll)];

T_y = [  cos(pitch)    0   sin(pitch);
           0           1      0;
         -sin(pitch)   0   cos(pitch)];
     
T_z = [  cos(yaw) -sin(yaw) 0;
         sin(yaw) cos(yaw)  0
         0 0 1];
        
        
        

T = T_x * T_y * T_z;

V=V*T;

      



