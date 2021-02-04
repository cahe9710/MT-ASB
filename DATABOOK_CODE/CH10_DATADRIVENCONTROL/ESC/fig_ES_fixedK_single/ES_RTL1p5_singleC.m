clear all
clc
close all

a1=   -0.3834;
a2=    0.0595;
a3=    0.4889;
a4=    1.5475;
a4 = 1.46;

K=.1;
g01 = 1.73;
e01=4.23;

Lt=60;  % length of t-domain
nt=256; % number of time points
RTLength = 1.5;
t2=linspace(-Lt/2,Lt/2,nt+1); 
t=t2(1:nt);
U_intCanon(1:nt,1)=sech(t/2);
U_intCanon(nt+1:2*nt,1)=sech(t/2);
U_int = U_intCanon;

% run simulation once to get initial condition
[U_out, phi_out, energy, M4, M6, pulseError, pulseInd, normlength] = SingleNPR(U_int, a1, a2, a3, a4, K, g01, e01,Lt,nt, RTLength);
y0 = energy/M4; % initial objective function

% Extremum Seeking Control Parameters
% hardware sampling frequency
params = 4;
freq1 = 50; % sample frequency
dt = 1/freq1;
T = 3600; % total period of simulation (in seconds)

% high pass filter
butterorder=1;
butterfreq=2;  % in Hz for 'high')
[b,a] = butter(butterorder,butterfreq*dt*2,'high')

% perturbation parameters
amp =.25*pi/180;
% omegas = 2*[0*2*pi 0*2*pi 4.512*pi 4.512*pi];
% phase = [0  pi/2 0  pi/2];
% gain = .5*[0*20 0*20 40 40]*dt;
omegas = [0*2*pi 0*2*pi 0*4.512*pi 2*pi];
phase = [0  pi/2 0  pi/2];
gain = .5*[0*20 0*20 0*20 20]*dt;

avals = [a1;a2;a3;a4];
ys = zeros(params,butterorder+1)+y0;
HPF=zeros(params,butterorder+1);

allavals=[];
avalhat = avals;
yvals=[];
time = [];
energies = [];
M4s = [];
M6s = [];
% xis = [];
% HPS=[];
ahats = [];

t0 = 0;

% load dummy.mat
% ind = 131;
% ys(:,:) = yys(ind,:,:);
% HPF(:,:) = HPS(ind,:,:);
% avals(:) = allavals(:,ind);
% avalhat = ahats(:,ind);
% t0 = time(ind);
% U_out(:,:) = Uvals(ind,:,:);
% 
% amp = .1*pi/180;
% 
% gain = gain*25;
% % freq1 = 100; % sample frequency
% % dt = 1/freq1;
% % T = 120; % total period of simulation (in seconds)
% % 
% % % high pass filter
% % butterorder=3;
% % butterfreq=2*pi/(2*pi);  % in Hz for 'high')
% % [b,a] = butter(butterorder,butterfreq*dt/2,'high')
% % gain = [6 6 10 10]*dt;


for i=1:T/dt
    t = t0 + (i-1)*dt
    
    K = .1;% + .4*t/T
    % detect newest value of objective function
    U_int = U_out;
    [U_out, phi_out, energy, M4, M6, pulseError, pulseInd, normlength] = SingleNPR(U_int, avals(1), avals(2), avals(3), avals(4), K, g01, e01,Lt,nt, RTLength);
    yout = energy/M4
    energy
    yvals=[yvals; yout];
    for j=1:params
        for k=1:butterorder
            ys(j,k) = ys(j,k+1);
            HPF(j,k) = HPF(j,k+1);
        end
        ys(j,butterorder+1) = yout;
        
        HPFnew = 0;
        for k=1:butterorder+1
            HPFnew = HPFnew + b(k)*ys(j,butterorder+2-k);
        end
        for k=2:butterorder+1
            HPFnew = HPFnew - a(k)*HPF(j,butterorder+2-k);
        end
        HPFnew = HPFnew/a(1);
        HPF(j,butterorder+1) = HPFnew;
        
        aval = avals(j);
        %         avalhat = aval - amp*sin(omegas(j)*(i-1)*dt + phase(j));
        xi = HPFnew*sin(omegas(j)*t + phase(j));
        xis(j,i) = xi;
%         if(i<5) xi = 0;
%         end
        avalhat(j) = avalhat(j) + xi*gain(j);
        avals(j) = avalhat(j) + amp*sin(omegas(j)*t + phase(j));
    end
%     HPS=[HPS;HPFnew];
    HPS(i,:,:) = HPF(:,:);
    yys(i,:,:) = ys(:,:);
    ahats = [ahats avalhat(:)];
    allavals = [allavals avals];
    energies = [energies; energy];
    M4s = [M4s; M4];
    M6s = [M6s; M6];

    time = [time; t];
    Uvals(i,:,1) = U_out(:,:);
    
    if(mod(i,5*freq1)==0)
        save ES_RTL1p5_singleC_dat.mat time yvals allavals energies  xis
    end
    
end