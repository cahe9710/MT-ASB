function  [T, eta] = propeller(Pd,Vx)

eta  =  0.5 * min(1,Vx/5); % Efficiency
T    =  eta * Pd/Vx;       % Propeller efficiency






