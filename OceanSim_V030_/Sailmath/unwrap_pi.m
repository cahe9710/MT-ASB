function x = unwrap_pi(x);

%while x<pi; x = x+2*pi; end
%while x>pi; x = x-2*pi; end

x = x + (x<-pi)*2*pi - (x>pi)*2*pi;
x = x + (x<-pi)*2*pi - (x>pi)*2*pi;
x = x + (x<-pi)*2*pi - (x>pi)*2*pi;

