function [U_out, phi_out, energy, M4, M6, pulseError, pulseInd, normlength] = SingleNPR(U_int, a1, a2, a3, ap, K, g01, e01, Lt, nt, RTlength)

%Jones Matrices
W_q=[exp(-1i*pi/4) 0; 0 exp(1i*pi/4)];
W_h=[-1i 0; 0 1i];
W_p=[1 0; 0 0];
J_1=R_matrix(a1)*W_q*R_matrix(-a1);
J_2=R_matrix(a2)*W_q*R_matrix(-a2);
J_3=R_matrix(a3)*W_h*R_matrix(-a3);
J_p=R_matrix(ap)*W_p*R_matrix(-ap);

D=-0.4; % dispersion parameter
A=2/3; % fixed term in Schroedinger equation
B=1/3; % fixed
tau=0.1; % 
Gamma=0.1; 
mode=0;
% RTlength=1.0;
% 
% Lt=100;  % length of t-domain
% nt=256; % number of time points
t2=linspace(-Lt/2,Lt/2,nt+1); 
t=t2(1:nt);
dt=Lt/nt;

% Spectral K Values 
kt2=(2*pi/Lt)*nt/2*linspace(-1,1,nt+1);
kt=fftshift(kt2(1:nt)).';

U_int_0_s(1:nt,1)=fft(U_int(1:nt));
U_int_0_s((nt+1):(2*nt),1)=fft(U_int((nt+1):(2*nt)));
maxTrips = 50;%250;
change_norm=1.e+1000;
norms=[];
j = 1;
while (j<=maxTrips && change_norm>1.e-3)
    if j==1
        U_int_s=U_int_0_s;
    else
        U_int_s=[fft(U_solution(1:nt,j-1));fft(U_solution((nt+1):2*nt,j-1))];
    end
    % integrating FFT'd ODE for NLSE
    options = odeset('RelTol',1e-4,'AbsTol',1e-3*ones(nt*2,1));
    [z,U]=ode45(@(z,U) CNLS_fft_rhs(z,U,kt,D,K,A,B,g01,e01,tau,Gamma,dt,t,nt),[RTlength*(j-1):0.01:RTlength*j],U_int_s,options);
    % iFFT to back out u, v at spatial end of round trip
    u_end=ifft(U(end,1:nt));
    v_end=ifft(U(end,(nt+1):(2*nt)));
    % Apply Jones Matrix
    U_end=J_1*J_p*J_2*J_3*[u_end;v_end];
    % solution containing both small u and v
    U_solution(:,j)=[U_end(1,:).'; U_end(2,:).'];
    U_solution_output(:,j)=U_solution(:,j);
   if(j~=1)
       phi=sqrt(abs(U_solution_output(1:nt,:)).^2+abs(U_solution_output((nt+1):2*nt,:)).^2);
       change_norm=norm((phi(:,end)-phi(:,end-1)))/norm(phi(:,end-1));
       norms=[norms; change_norm];
   end
   j = j+1;
end
RoundTrips=j-2;

solution_end=phi(:,end);
energy=sqrt(trapz(solution_end.^2)*dt);
% [pulseError,pulseInd]=pulse_check(solution_end,t,nt);
pulseError = 0;
pulseInd = 0;
map=[0 0 0];
% waterfall(t,[0:10:2*RoundTrips],abs(phi(:,1:5:end)).'),view([.1 -.2 1]),xlabel('t'),ylabel('z'),zlabel('|\phi|'),zlim([0,9]),colormap(map);
% figure;
% plot(phi(:,end));
M4=moment(abs(fftshift(fft(phi(:,end)))),4)/std(abs(fftshift(fft(phi(:,end)))))^4; % fourth moment
M6=moment(abs(fftshift(fft(phi(:,end)))),6)/std(abs(fftshift(fft(phi(:,end)))))^6; % sixth moment

phi_out = phi(:,end);
U_out = U_solution(:,end);
normlength=length(norms);