function K=PIDF_Design(G0,Wcg0,Mphi0,Ni,WiR,Nf,WfR)

%******** Design of a PIDF controller *********
%
%K=PIDF_Design(G0,Wcg0,Mphi0,Ni,WiR,Nf,WfR)
%
%G0: definition of the nominal plant transfer function (tf object)
%Wcg0: desired nominal open-loop gain crossover frequency (rad/s)
%Mphi0: desired nominal phase margin (default: 40°)
%Ni: integral order (default: 1)
%WiR: ratio Wcg0/Wi for the integral part of the controller (default: 5)
%Nf: low-pass order of the controller (default: 1)
%WfR: ratio Wf/Wcg0 for the low-pass part of the controller (default: 5)
%
%K(s) = K0 * ((1+s/Wi)/(s/Wi))^Ni
%          * ((1+s*/W1)/(1+s/W2))^Nd
%          / (1+s/Wf))^Nf
%
%proposed by Patrick Lanusse (ENSEIRB) 11-15-2008


str = class(G0);

if (nargin <2)|~strcmp(str, 'tf')
    % 'Nominal plant transfer function and phase margin need to be defined'
    K=[];
else
    if nargin <3
        Mphi0=40;
    end
    if nargin <4
        Ni=1;
    end
    if nargin <5
        WiR=5;
    end
    if nargin <6
        Nf=1;
    end
    if nargin <7
        WfR=5;
    end

    [M0,P0]=bode(G0,Wcg0);
    if P0>0
        P0=P0-360;
    end
    s=tf([1 0],[1]);

    PhiM=-pi+(Mphi0-P0)*pi/180-Ni*(atan(WiR)-pi/2)+Nf*atan(1/WfR);
    Nd=ceil(abs(PhiM));
    alpha=tan((PhiM/Nd+pi/2)/2);

    Wi=Wcg0/WiR;
    Wf=Wcg0*WfR;
    Ki=((1+s/Wi)/(s/Wi))^Ni;
    Kf=1/(1+s/Wf)^Nf;
    Kd=((1+s*alpha/Wcg0)/(1+s/alpha/Wcg0))^Nd;

    K=Ki*Kf*Kd;

    [M,P]=bode(K*G0,Wcg0);

    K=K/M;
end