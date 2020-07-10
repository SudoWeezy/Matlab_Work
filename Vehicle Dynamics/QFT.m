%%Initialisation
s=tf('s');
%%
Tsec=2;
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
var1=[200,250];           %kg         Masse du 1/4 de véhicule
g=9.81;            %Nm/kg      Gravite

b3 = 23.9;
b4 = 242;
b5 = 0;

var1=[200,250];
var2=[0.1,0.5,1];% mu
var3=[10/3.6,50/3.6,90/3.6];% vitesse
indice=0;
for i1=1:2
    for i2=1:3
        for i3=1:3
            
            m=var1(i1);
            mu=var2(i2);
            Vx0=var3(i3);
            if i3<3||i2>1
                indice=indice+1;
                Fz=m*g;
                
                %% calcule de la pente ax
                Z=Fz*1e-3;
                cx=mu*(b3*Z^2+b4*Z)*exp(-b5*Z); % N/%
                
                %% état initial
                %Vx0=70/3.6;
                FAE=1/2*ro*Sx*Cx*Vx0^2;
                Frr=(lambda0+lambda2*Vx0^2)*m*g;
                FXE=FAE+Frr;
                Te=1/cx*FXE;
                W0=1/r0*(Vx0/(1-(Te/100)));
                Cm0=r0*FXE+br*W0;
                %fx=20;
                fx=0;
                %alpha=10*pi/180;
                alpha=0;
                
                %% Saturation
                
                VMAX=200/3.6;
                VMIN=0.5/3.6;
                WMAX=VMAX/r0;
                WMIN=0;
                
                %% Linearisation
                Vxe=Vx0;
                ba=ro*Sx*Cx*Vxe;
                brr=2*lambda2*m*g*Vxe;
                %cx=mu*Bx*Cx*Dx;
                Teacc=((r0*W0)-Vxe)/(r0*W0);
                nacc=Vxe/(r0*W0*W0);
                muacc=-1/(r0*W0);
                
                Tefre=(r0*W0)/Vxe-1;
                nfre=r0/Vxe;
                mufre=-(r0*W0)/(Vxe*Vxe);
                nu=nacc;
                %%
                cxe=100*mu*(b3*Z^2+b4*Z)*exp(-b5*Z); % N/%;
                
                A=[[(mufre*cxe-ba-brr)/m nu*cxe/m];[-r0*mufre*cxe/J -r0*nu*cxe/J-br/J]];
                B=[0;-K/J];
                C=[0 1];
                D=[0];
                [numG,denG]=ss2tf(A,B,C,D);
                G=tf(numG,denG);
                wp=eig(A);
                wz=zero(G);
                tab1(indice)=wp(1);
                tab2(indice)=wp(2);
                tab3(indice)=wz;
                
                Gtest(indice)=tf(numG,denG);
                figure (1)
                
                bode(Gtest(indice));grid;
                
                hold on;
                figure (2)
                step(Gtest(indice));grid;
                hold on;
            end;
        end;
    end;
end;
%%

figure(3)
subplot(3,1,1)
plot(-tab1)
title('Variation de wp1');grid;
subplot(3,1,2)
plot(-tab2);
title('Variation de wp2');grid;
subplot(3,1,3)
plot(-tab3);
title('Variation de wz');grid;
%%
max(tab1);
min(tab1);
max(tab2);
min(tab2);
max(tab3);
min(tab3);
