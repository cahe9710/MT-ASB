function y = stair (x)
x=x+0.2000000000001;
% https://math.stackexchange.com/questions/1671132/equation-for-a-smooth-staircase-function
% clear;figure(999);clf;x = 0:0.01:20; for ii = 1:length(x); y(ii)=stair(x(ii));end; plot(x,y,'.-');grid on; zoom on

    h     = 0.25;    % Step height
    b     = 0.2;    % Flat width
    c     = 0.1;    % Curves width
    width = b + c;
    y_base  = floor(x/width);    % base of this step
    o     = mod(x,width);      % offset, between 0 and width

    if o<b
        y = h*y_base;
    else
        u = (o-b)/c;
        y = h*(y_base + 0.5 - 0.5 * cos(pi* u));
    end

end

