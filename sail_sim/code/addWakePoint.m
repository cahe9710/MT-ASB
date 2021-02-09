function p = addWakePoint(p,wakeType,wakeLength,environment)
%--------------------------------------------------------------------------
% p = addWakePoint(p,wakeType,wakeLength)
% 
% Function addWakePoint calculates and adds a wake point to the vector p
%
% -------- INPUT --------
%  p			- Matrix containing one row of point in the sail [x y z]'
%  wakeType		- Type of wake, 'free' or 'fixed'
%  wakeLength	- Fixed wake: wake length from T.E
%				  Free wake:  length of first wake element   
%
%-------- OUTPUT --------
%  p 			- Updated matrix p with added wake point
%
%--------------------------------------------------------------------------

if strcmp(wakeType,'fixed')
	% Calculate wake points so that they are aligned with freestream
	wind  = generateWind(p(3,end),environment); % Wind as function of z-cordinate, wind is a vector [u,v,w]
	wUnit = wind/norm(wind); % Unit vector in wind directions xy-plane
	p(:,end+1) = p(:,end) + wUnit*wakeLength; % Adds wake south node	
elseif strcmp(wakeType,'free')
	% Calculate wake point in the same direction as the trailing edge
	pNextDir = p(:,end)-p(:,end-1);
	p(:,end+1) =  p(:,end) + pNextDir/norm(pNextDir)*wakeLength; % Adds the south wake node
end