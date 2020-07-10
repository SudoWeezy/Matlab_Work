%%Initialisation
s=tf('s');
mu=1;
Vx0=70/3.6;
m=200;           %kg         Masse du 1/4 de véhicule
%%
Tsec=2;
%----------------------------------------------------------------------------------------
%------------------------ Paramètres pneu avec Pression de 3 bar ----------------------------
%----------------------------------------------------------------------------------------

%------------------------ Définition des unités ----------------------------
% Les forces Fz, fx et fy en N
% Le moment d'auto-alignement Mz en Nm
% La dérive en deg
% Le glissement en % ; ex: pour un glissement de 10% il faut rentrer 10
% L'adhérence sans unité

%-- Definition des paramètres du pneu

% Coefficient de raideur radial du pneumatique (N/m) + amo (N/(m.s))
kp=200000;
ap=100;

% Coefficients longitudinaux purs 
b0 = 1.65;
b1 = 0;
b2 = 1170;
b3 = 23.9;
b4 = 242;
b5 = 0;
b6 = 0;
b7 = 0;
b8 = 0;
b9 = 0;
b10 = 0;
b11 = 0;
b12 = 0;

% coefficients de couplage longitudinaux
bm0 = 1.22;
bm1 = 0;
bm2 = 0.232;
bm3 = -0.123;

% coefficients lateraux purs 
a0 = 1.712;
a1 = -66.87;
a2 = 1169;
a3 = 851.9;
a4 = 4.943;
a5 = 0.01399;
a6 = -0.1911;
a7 = 1;
a8 = -0.004375;
a9 = -0.003684;
a10 = -0.06845;
a111 = -13.92;
a112 = 0.5205;
a12 = 5.405;
a13 = 56.14;

% coefficients de couplage lateraux
am0 = 0.972;
am1 = 0;
am2 = 0.186;
am3 = 0.22;
am4 = 0;
am5 = 14.7;
am6 = 0;
am7 = 0;
am8 = 0.308;
am9 = 0.326;

% macro coefficients d'auto-alignement
c0 = 3.01;
c1 = -3.172;
c2 = -4.907;
c3 = -0.8253;
c4 = -4.842;
c5 = 0;
c6 = 0;
c7 = 0.0411;
c8 = -0.4518;
c9 = 0.9526;
c10 = 0.1612;
c11 = 0.01013;
c12 = -0.01282;
c13 = -0.04847;
c14 = 0.09192;
c15 = -0.5786;
c16 = 0.5442;
c17 = 0.575;

% Annulation des termes de couplage pour tests en ligne droite
% Problème de zéro numérique à la compilation 0=>1e-8.

% a9  = 1e-8;
% a10 = 1e-8;
% a12 = 1e-8;
% a13 = 1e-8;
% c12 = 1e-8;
% c13 = 1e-8;
% c16 = 1e-8;
% c17 = 1e-8;
pneu=[a0,a1,a2,a3,a4,a5,a6,a7,am0,am1,am2,am3,am4,am5,am6,am7,am8,am9,b0,b1,b2,b3,b4,b5,b6,bm0,bm1,bm2,bm3,c0,c1,c2,c3,c4,c5];
%% constantes
J=1;             %Kg.m2      Inertie roue
br=1e-3;        %Nm.s/rad   Coefficient de frottement visqueux
r0=0.3 ;         %m          Rayon de la roue sous charge
Sx=1;            %m2         Surface projetée longitudinalment pour 1/4 du véhicule
Cx=0.5;          %           Coefficient de trainée longitudinale
ro=1.225;        %kg/m3      Masse volumique de l'air
lambda0=13.6e-3;   %s/m2       Constante de la résistance au roulement
lambda2=4e-8; %s/m2       Constante de la résistance au roulement
K=125;           %Nm/V       Gain statique de l actionneur EMB
Kp=100;          %V/m        Gain statique de la pedale de frein
cp=0.12;         %m          Course de la pérale de frein

g=9.81;            %Nm/kg      Gravite
Fz=m*g;         %N

%% calcule de la pente ax
Z=Fz*1e-3;
cx=mu*(b3*Z^2+b4*Z)*exp(-b5*Z); % N/%
%cx=Bx*Cx*Dx;
%% état initial

FAE=1/2*ro*Sx*Cx*Vx0^2;
Frr=(lambda0+lambda2*Vx0^2)*m*g;
FXE=FAE+Frr;
Te=1/cx*FXE;
W0=1/r0*(Vx0/(1-(Te/100)));
Cm0=r0*FXE+br*W0;
%%
fx=0;
%fx=150/3.6;
%alpha=10*pi/180;
alpha=0;
muvar=0.1;
%% Saturation

VMAX=200/3.6;
VMIN=0.5/3.6;
WMAX=VMAX/r0;
WMIN=0;

%% Linearisation
Vxe=Vx0;
W0e=W0;

ba=ro*Sx*Cx*Vxe;
brr=2*lambda2*m*g*Vxe;

Teacc=((r0*W0e)-Vxe)/(r0*W0e);
nacc=Vxe/(r0*W0e*W0e);
muacc=-1/(r0*W0e);

Tefre=(r0*W0e)/Vxe-1;
nfre=r0/Vxe;
mufre=-(r0*W0e)/(Vxe*Vxe);


Jr=J;
cxe=cx*100; % car N/%;

A=[[(mufre*cxe-ba-brr)/m nfre*cxe/m];...
    [-r0*mufre*cxe/Jr -r0*nfre*cxe/Jr-br/Jr]];

B=[0;-K/Jr];
C=[0 1];
D=[0];
Valeur_propre=eig(A)

[numG,denG]=ss2tf(A,B,C,D);

G=tf(numG,denG);
zpk(G)


%%
[Al,Bl,Cl,Dl]=linmod('DVNonlineairelinmod');

[numGl,denGl]=ss2tf(Al,Bl,Cl,Dl);
Gl=tf(numGl,denGl);
zpk(Gl)

% [Al,Bl,Cl,Dl]=linmod('DVLineairelinmod');
% 
% [numGl2,denGl2]=ss2tf(Al,Bl,Cl,Dl);
% Gl2=tf(numGl2,denGl2);
% zpk(Gl2)
% % % figure(2)
% % % bode(G,Gl,Gl2);grid;

%%
figure(3)
bode(G,Gl);grid;
legend('Modèle linéarisé','Modèle linmod')
%% régulateur P
zpk(G)
Co=tf(-1.2)
figure(4)
bode(Co*G);grid;

figure(5)
nichols(G*Co);grid;
%%
figure(7)
bode(1/(1+Co*G),'-r')
hold on
bode(G/(1+Co*G),'-.b')
bode(-Co*G/(1+Co*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de la sortie');grid;

figure(8)
bode(-1/(1+Co*G),'-r')
hold on
bode(-G/(1+Co*G),'-.b')
bode(-1/(1+Co*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de l erreur');grid;

figure(9)
bode(Co/(1+Co*G),'-r')
hold on
bode(-G*Co/(1+Co*G),'-.b')
bode(-Co/(1+Co*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de la commande');grid;
%% régulateur QFT

Correcteur=(-1.2*s-1.8)/(0.01*s^2+s)
%%
close all;
figure(10)
bode(1/(1+Correcteur*G),'-r')
hold on
bode(G/(1+Correcteur*G),'-.b')
bode(-Correcteur*G/(1+Correcteur*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de la sortie');grid;

figure(11)
bode(-1/(1+Correcteur*G),'-r')
hold on
bode(-G/(1+Correcteur*G),'-.b')
bode(-1/(1+Correcteur*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de l erreur');grid;

figure(12)
bode(Correcteur/(1+Correcteur*G),'-r')
hold on
bode(-G*Correcteur/(1+Correcteur*G),'-.b')
bode(-Correcteur/(1+Correcteur*G),'.k')
legend('Perturbation en sortie','Perturbation en entrée','bruit de mesure')
title('Sensibilite de la commande');grid;
%%

figure(13)
bode(Correcteur*G);grid;

figure(14)
nichols(Correcteur*Co);grid;
