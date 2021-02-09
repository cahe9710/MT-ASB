function [results, CEH, CEA, CEY] = calcCE(sails, results)
%--------------------------------------------------------------------------
% [results CE] = calcCE(sails, results)
% 
% Function calcCE calculates the centre of effort on the sail
% defined in sails and results
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc of
%                 all sails
%   results     - Structure containing forces, pressures, etc. of
%                 all sails
%
%-------- OUTPUT --------
%   results     - Structure containing forces, pressures, etc. of
%                 all sails. Updated results(:).ce
%   CEH         - The z coordinate of the centre of effort
%   CEA         - The x coordinate of the centre of effort
%
%--------------------------------------------------------------------------

sum1 = 0; sum2 = 0;

for is = 1:length(sails) % sail loop
    Mtot = 0; Cea = 0; Ceh = 0; Cey = 0;
    for ix = 1:sails(is).Nx % chordwise loop
        for iz = 1:sails(is).Nz % spanwise loop
            % Caclulate centre of pressure
            Mtot = Mtot + cross(results(is).lattice(ix,iz).f, sails(is).lattice(ix,iz).ca);
%             Ceh = Ceh + results(is).lattice(ix,iz).f(2)*sails(is).lattice(ix,iz).ca(3)/results(is).f(2);
%             Cey = Cey + results(is).lattice(ix,iz).f(2)*sails(is).lattice(ix,iz).ca(2)/results(is).f(2);
%             Cea = Cea + results(is).lattice(ix,iz).f(2)*sails(is).lattice(ix,iz).ca(1)/results(is).f(2);
            
            Ceh = Ceh + (norm(results(is).lattice(ix,iz).f))*(sails(is).lattice(ix,iz).ca(3)-sails(is).lattice(1,1).ca(3))/norm(results(is).f);
            Cey = Cey + (norm(results(is).lattice(ix,iz).f))*(sails(is).lattice(ix,iz).ca(2)-sails(is).lattice(1,1).ca(2))/norm(results(is).f);
            Cea = Cea + (norm(results(is).lattice(ix,iz).f))*(sails(is).lattice(ix,iz).ca(1)-sails(is).lattice(1,1).ca(1))/norm(results(is).f);
%             if sails(is).mir == 1;
%                 Mtot = Mtot + cross(sails(is).lattice(ix,iz).ca.*[1 1 -1]', results(is).lattice(ix,iz).f);
%             end
        end
    end
%     disp(Mtot);
    results(is).ce  = Mtot./results(is).f;
    results(is).ceh = Ceh+sails(is).lattice(1,1).ca(3); %Mtot(1)/results(is).f(2);% Ceh/1.902; %
    results(is).cea = Cea+sails(is).lattice(1,1).ca(1); %Mtot(3)/results(is).f(2);% Cea;
    results(is).cey = Cey+sails(is).lattice(1,1).ca(2);
    
    if sails(is).mir == 1; results(is).ce(3) = 0; end
    
    
    sum1 = sum1 + abs(Mtot);
    sum2 = sum2 + results(is).f;
    
    mCea(is) = results(is).cea*norm(results(is).f);
    mCeh(is) = results(is).ceh*norm(results(is).f);
    mCey(is) = results(is).cey*norm(results(is).f);
    sumF(is) = norm(results(is).f);
end

% CEH = sum1(1)/sum2(2);
% CEA = sum1(3)/sum2(2);
% CEY = sum1(2)/sum2(2);
CEA = sum(mCea)/sum(sumF);
CEH = sum(mCeh)/sum(sumF);
CEY = sum(mCey)/sum(sumF);
