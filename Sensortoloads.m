%% Simulated sensor output
%Sensors placed at positive x positive y and negative x direction seen from mast centre
X= [epsilonuz(length(fi)/2+.5), epsilonuz(length(fi)/2+.5+90), epsilonuz(end);
    epsilonlz(length(fi)/2+.5), epsilonlz(length(fi)/2+.5+90), epsilonlz(end);
    gammao(length(fi)/2+.5), gammao(length(fi)/2+.5+90), gammao(end);
    gammab(length(fi)/2+.5) gammab(length(fi)/2+.5+90), gammab(end)];
%% mast data
d=70*10^-3; %mast diamaeter [m]
t=3*10^-3; %Mast wall thisckness [m]
l1=0.85; %Distance between bearings [m]
E= 70*10^9; %Elsatic modulus for aluminium
poissons= 0.33; %Poisson's ratio for aluminium
G= E/(2*(1-poissons)); %Shear modulus for alumninium
a=d/2-t/2; %Mean radius of mast
Wb=pi()/4*a^2*t; %Bending resistance of mast (thin walled tube)
Wv=pi()*a^2*t; %Torsion resistance of mast (thin walled tube)
I=pi()/4*a^3*t; %Moment of inertia for mast cross section in bending direction (thin walled tube)
A=2*pi()*a*t; %Cross-sectional area of mast (thin walled tube)
Sa= 2*a^2*t; %Static moment of a halfcircle with mean radius a and thickness t
%% Amplitude and mean calculation
C= (X(:,1)+X(:,3))/2;
Y= [X(:,1)-C,X(:,2)-C];
Theta= zeros(4);
Amp= zeros(4);
for i=[1:4]
    if Y(i,2)>0
        Theta(i)=atan(Y(i,1)/Y(i,2));
    elseif Y(i,2)<0
        Theta(i)=atan(Y(i,1)/Y(i,2))+sign(Y(i,1))*pi();
    elseif Y(i,1)>0
        Theta(i)=pi()/2;
    elseif Y(i,1)<0
        Theta(i)=-pi()/2;
    else
        Theta(i)= 100;
    end
    if Theta(i) < 100
        if pi()/4< abs(Theta(i))&& abs(Theta(i))<3*pi()/4
            Amp(i)=Y(i,1)/sin(Theta(i));
        else
            Amp(i)=Y(i,2)/cos(Theta(i));
        end
    else
        Amp(i)=0;
    end
end
%% sensors to loads
Fzcalc=mean(C([1,2]))
Mycalc=Y(1,1)*E*Wb
Mxcalc=-Y(1,2)*E*Wb
Mzcalc=mean(C([3,4]))*G*Wv
Fxcalc=-Y(3,2)*G*I*2*t/Sa
Fycalc=Y(3,1)*G*I*2*t/Sa
Txcalc=-Y(4,2)*G*I*2*t/Sa
Tycalc=Y(4,1)*G*I*2*t/Sa
Mtotcalc=Amp(1)*E*Wb
Ftotcalc=Amp(3)*G*I*2*t/Sa
Ttotcalc=Amp(4)*G*I*2*t/Sa