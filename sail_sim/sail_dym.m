function y = sail_dym(wingsAngles)

addpath('code');
%clear;
% close all;

%% 2D trim angles from J
% trimAngles2D = importdata('4wings_7m.txt');
% 
% % flapAng = -25; % Flap angle for all rigs. Has to be negative if wing Angle >0
% % 
% % AWAvec = [33.5 62.7 99.5 180];
% % AOAVec = [0 8 12 16 30];
% % 
% % flapsAngles = repmat(0,1,length(AWAVec));
% 
% % AWAvec = 0;
% % 
% % AOA = 10;
% % wingsAngles = AWAvec - AOA;
% 
% 
% AWAvec = trimAngles2D.data(:,1);
% % % 
% flapsAngles = repmat(0,length(AWAvec),4);
% % wingsAngles = repmat(AWAvec - AOA,1,4);
% wingsAngles = [trimAngles2D.data(:,2),...
%     trimAngles2D.data(:,3),...
%     trimAngles2D.data(:,4),...
%     trimAngles2D.data(:,5)];

% wingsAngles = [trimAngles2D.data(:,2),...
%     trimAngles2D.data(:,4),...
%     trimAngles2D.data(:,6),...
%     trimAngles2D.data(:,8)];
% flapsAngles = [trimAngles2D.data(:,3),...
%     trimAngles2D.data(:,5),...
%     trimAngles2D.data(:,7),...
%     trimAngles2D.data(:,9)];

AWAvec = 45;%20:2.5:170;
% wingsEq = [1.1291  -34.6081
%     1.0230  -22.6454
%     0.9395  -13.0952
%     0.8556   -3.7279];
% for ii = 1:4
%     wingsAngles(:,ii) = polyval(wingsEq(ii,:),AWAvec);
% end
flapsAngles = zeros(length(AWAvec),4);

%% Constant VLM parameters

    
% Environmental varibles
environment.tws 	= 10;   % Here used as freestream velocity, freestream is uniform
environment.rho 	= 1.2; % Air density
environment.vs  	= 0;   % not used
environment.mir     = 1;   % =1 for mirroring geometry in z = 0 in calculations. 

% Environmental varibles
global tws twa rho vs
tws = environment.tws; % Here used as freestream velocity, freestream is uniform
% twa = environment.twa; % True wind angle
rho = environment.rho; % Air density
vs  = environment.vs;  % not used
mir = environment.mir;

environment.inflow = 'uniform'; % can be: "BL", "twisted" or "uniform". BL: ITTC wind profile used, but no boat speed. Twisted: BL + boat speed accounted for
environment.zRef = 10; %m, height at which wind is defined
environment.windOffset = 29; % Offset from deck height (wing geomtrically close to 0hiehgt for miroring)
environment.BoatSpeed = 0*1852/3600; %Boat speed in m/s
environment.BoatKG = [100,0,25]; %From SSPA hydro in VPP

heelAngle = 0; 

dxW = 0.1925;                % Same for all wings in this case
flapPos= [-0.1148 ; 0 ;0 ];%[-6.7146; 0;0];    %  %Same for all wings in this case
dxF=0;                      % Same for all wings in this case

% RIGS DISRETIZATION
Nxwing = 3;                  % Same for all wings in this case
Nxflap = 6;                % Same for all flaps in this case
Nzall = 9;                 % Same for all flaps and wings, in all cases

% WAKE Parameters
wakeTypeAll = 'fixed'; 
wakeLengthAll = 100;
rCoreTot = 1e-10;
NxwakeWing = 1;
wakeCoreKr = 0.5; %kr Used only for wakeType free
wakeStepAll = 1; % Used only for wakeType free

% RIGS Postion and angles
originWing1 = [0.9; 0; 0];%[170; 0; 36];% 
originWing2 = [2.5; 0; 0];
originWing3 = [4.1; 0; 0];
originWing4 = [5.7; 0; 0];
originWings = [originWing1, originWing2, originWing3, originWing4];
%%
% fileName = sprintf('VLM_7m_results_fits_skdhc.txt');
% fid = fopen(fileName, 'a');
% fprintf(fid, 'AWA\tCL\tCD\tCEx\tCEy\tCEz\tCMx\tCMy\tCMz\tWing1\tWing2\tWing3\tWing4\r\n');
% fclose(fid);


FA = zeros(length(AWAvec),2);
CEA = zeros(length(AWAvec),3);
Faero = zeros(length(AWAvec),2);
Maero = zeros(length(AWAvec),2);

for k = 1:length(AWAvec)
    clearvars rigs results
    
geom = getGeometry('geom_7m_3.txt',dxW,flapPos,dxF);

%%

for ii = 1:4
% ii=1;
    rigs(ii).wing = geom.wing;
    rigs(ii).wing.Nx = Nxwing;
    rigs(ii).wing.Nz = Nzall;
    rigs(ii).wing.Type = 'wing';
%     rigs(ii).wing.sheetAngle = deg2rad(wingAngle1);
    rigs(ii).wing.flapAngle = 0 ;        % Only uselful for flap but needed to have same struct
    rigs(ii).wing.flapAxis = [0; 0; 0];  % Only uselful for flap but needed to have same struct
    rigs(ii).wing.dX = dxW;
%     rigs(ii).wing.heelAngle = deg2rad(heelAngle);
    rigs(ii).wing.wingOrigin = originWings(:,ii);
    rigs(ii).wing.mir = mir;               % TO DO make mirorring with deck height
    
    rigs(ii).flap = geom.flap;
    rigs(ii).flap.Nx = Nxflap;
    rigs(ii).flap.Nz = Nzall;
    rigs(ii).flap.Type =  'flap';
%     rigs(ii).flap.sheetAngle = rigs(ii).wing.sheetAngle;
%     rigs(ii).flap.flapAngle = deg2rad(flapAngle1);
    rigs(ii).flap.flapAxis = flapPos;
    rigs(ii).flap.dX = dxF;
%     rigs(ii).flap.heelAngle = deg2rad(heelAngle);
    rigs(ii).flap.wingOrigin = originWings(:,ii);
    rigs(ii).flap.mir = mir;
%     rigs(ii).wing.panels = meshRig(rigs(ii).wing, 'linear');
%     rigs(ii).flap.panels = meshRig(rigs(ii).flap, 'linear');
    
    rigs(ii).Rcore = rCoreTot; % vortex core size
%     rigs(ii).panels = orderRigPanels(rigs(ii).wing,rigs(ii).flap);
    rigs(ii).Nx = rigs(ii).wing.Nx+rigs(ii).flap.Nx;
    rigs(ii).Nz = rigs(ii).wing.Nz;
    rigs(ii).mir = mir; % Used only to mirror the plots
    rigs(ii).wakeType = wakeTypeAll;
    rigs(ii).wakeLength = wakeLengthAll;
    rigs(ii).Nxw = NxwakeWing;
    rigs(ii).kr = wakeCoreKr;
    rigs(ii).wakeStep = wakeStepAll;
end
%%
% FA = zeros(length(AWAvec),2);
% CEA = zeros(length(AWAvec),3);
% Faero = zeros(length(AWAvec),2);
% Maero = zeros(length(AWAvec),2);
% cea = zeros(length(AWAvec),3);
% k = 1;
% liftVec2 = zeros(length(AWAvec),length(AOAVec));
% dragVec2 = zeros(length(AWAvec),length(AOAVec));

%for k = 1:1:length(AWAvec)

%     for jj = 1:length(AOAVec)
%         wingAng = AWAvec(k) - AOAVec(jj);
%         wingsAngles(k,:) = repmat(wingAng,1,4);
        for ii = 1:length(rigs)
            rigs(ii).wing.sheetAngle = deg2rad(wingsAngles(k,ii));
            rigs(ii).wing.heelAngle = deg2rad(heelAngle);
            rigs(ii).flap.sheetAngle = rigs(ii).wing.sheetAngle;
            rigs(ii).flap.flapAngle = deg2rad(flapsAngles(k,ii));
            rigs(ii).flap.heelAngle = deg2rad(heelAngle);

            rigs(ii).wing.panels = meshRig(rigs(ii).wing, 'linear');
            rigs(ii).flap.panels = meshRig(rigs(ii).flap, 'linear');
            rigs(ii).panels = orderRigPanels(rigs(ii).wing,rigs(ii).flap);
        end

    % k=1;
        twa = deg2rad(AWAvec(k));
        disp(AWAvec(k));
%         disp(AOAVec(jj));

        rigs = preProcessor(rigs,environment);
        rigs = solver(rigs,mir,environment);
        if strcmp(wakeTypeAll,'free')
            rigs = freeWake(rigs,mir,environment);
            rigs = solver(rigs,mir,environment);
        end
        results = postProcessor(rigs, mir,environment);
%         if(k==1)
%            plotLattice(rigs,k);
%            plotPressure(rigs,results,k+100);
%            plotForces(rigs,results,k);
%         end
%        disp(sprintf('Lift: %.2f N',results(1).L));
%        disp(sprintf('Drag: %.2f N',results(1).D));

%         drawnow;
        FA(k,1) = results.CX;
        FA(k,2) = results.CY;
        FA(k,3) = results.CZ;

        Faero(k,1) = results.CL;
        Faero(k,2) = results.CD;

        CEA(k,1) = results.CEA;
        CEA(k,2) = results.CEY;
        CEA(k,3) = results.CEH;
        
        Maero(k,1)= (results(1).FY*((results(1).CEH+environment.windOffset)))/(0.5*1.2*tws^2*results(1).A);
        Maero(k,2)= (results(1).FX*(results(1).CEA-environment.BoatKG(1)))/(0.5*1.2*tws^2*results(1).A);
        Maero(k,3) = (results(1).FX*(results(1).CEY-environment.BoatKG(2))+...
        results(1).FY*(results(1).CEA-environment.BoatKG(1)))/(0.5*1.2*tws^2*results(1).A);
        
        
%         liftVec(k,jj) =  results.L;
%         dragVec(k,jj) =  results.D;
%     end
%     if(AWAvec(k) ~= 100)
%     fid = fopen('vlm_test2', 'a');
%     fprintf(fid,'%i\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n',...
%         AWAvec(k),...
%         results(1).CL,...
%         results(1).CD,...
%         (results(1).CEA),...
%         (results(1).CEY),...
%         (results(1).CEH));
%     fclose(fid);
% fid = fopen(fileName, 'a');
% % for k = 1:length(AWAvec)
% %AWA\tCL\tCD\tCEx\tCEy\tCEz\tWing1\tWing2\tWing3\tWing4\r\n     %CMx\tCMy\tCMz\t
%     fprintf(fid,'%i\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.1f\t%.1f\t%.1f\t%.1f \r\n',... \t%.2f\t%.2f\t%.2f
%     AWAvec(k),...    FA(k,1),...    FA(k,2),...    FA(k,3),...
%     Faero(k,1),...
%     Faero(k,2),...
%     CEA(k,1),...
%     CEA(k,2),...
%     CEA(k,3),...    Maero(k,1),...    Maero(k,2),...    Maero(k,3),...
%     wingsAngles(k,1),...
%     wingsAngles(k,2),...
%     wingsAngles(k,3),...
%     wingsAngles(k,4));
% % end
% fclose(fid);
%     end
    
    
end

y = [results(1).fx; results(2).fx; results(3).fx; results(4).fx];

% for i =1:length(AWAvec)
%     fprintf('%f\t%f\t%f\t%f\t%f\t%f\n', AWAvec(i), Faero(i,1),Faero(i,2),CEA(i,1),CEA(i,2),CEA(i,3))
% end
% figure;
% plot(AWAvec, Faero(:,1));
