function out=pacejka_BE_Matlab_fnc(in)

derive=in(1);   % en degré
tau=in(2);      % en %
Fz=in(3);       % en N
mu=in(4);       % sans dimensions 0.1 < mu < 1
pneu=in(5:end);
Gamma=0;        % en degré

Z=Fz*1e-3; % Z en kN


a0=pneu(1);
a1=pneu(2);
a2=pneu(3);
a3=pneu(4);
a4=pneu(5);
a5=pneu(6); 
a6=pneu(7);
a7=pneu(8);
am0=pneu(9); 
am1=pneu(10); 
am2=pneu(11); 
am3=pneu(12); 
am4=pneu(13); 
am5=pneu(14); 
am6=pneu(15); 
am7=pneu(16); 
am8=pneu(17); 
am9=pneu(18); 
b0=pneu(19);  
b1=pneu(20);  
b2=pneu(21);  
b3=pneu(22);
b4=pneu(23); 
b5=pneu(24);  
b6=pneu(25);  
bm0=pneu(26);  
bm1=pneu(27);  
bm2=pneu(28);  
bm3=pneu(29);  
c0=pneu(30);
c1=pneu(31);
c2=pneu(32);
c3=pneu(33);
c4=pneu(34);
c5=pneu(35); 


%----FY----%
%-- ENTREES
%angle_derive en °
%Fz en N
%-- SORTIES
%Fy en N
    C_0=a0;
    C=C_0;
    D=a1*Z^2+a2*Z;
    %SH_0=a9*Z+a10;
    %SH=SH_0+a8*Gamma;
    SH=0;
    %SV_0=a12*Z+a13;
    %SV=SV_0+(a112*Z^2+a111*Z)*Gamma;
    SV=0;
    BCD_0=a3*sin(2*atan(Z/a4));
    BCD=BCD_0*(1-a5*abs(Gamma));
    B=BCD/(C*D);
    E=a6*Z+a7;
    PHI=(1-E)*(derive+SH)+(E/B)*atan(B*(derive+SH));
    Fy0=D*sin(C*atan(B*PHI))+SV;
    %COUPLAGE
    CG=am0;
    BG=am2*cos(atan(am3.*(derive-am4)));
    der_BG=-am2*am3.*sin(atan(am3.*(derive-am4)))*1./(1+(am3.*(derive-am4)).^2);
    AG=am1;
    Ga0=am6*Z+am7;
    fyxgli=sin(1.9*atan(am8*tau));
    fyxder=cos(atan(am9.*derive));
    Gy_u=cos(CG*atan(BG.*(tau-AG)));
    der_Gy_u=-sin(CG.*atan(BG.*(tau-AG))).*CG.*(1./(1+(BG.*(tau-AG)).^2)).*der_BG.*(tau-AG);
    Gy_v=cos(CG*atan(BG*(-AG)));
    der_Gy_v=-sin(CG.*atan(BG.*(-AG))).*CG.*(1./(1+(BG.*(-AG)).^2)).*der_BG.*(-AG);
    Gy=Gy_u./Gy_v;
    Fyx=am5.*Z.*(Gamma-Ga0.*fyxder.*fyxgli);
    %     EFFORT TRANSVERSAUX AVEC COUPLAGE
    Fy=mu.*(Fy0.*Gy+Fyx);


%----Fx----%
%-- ENTREES
%derive en °
%Fz en N
%-- SORTIES
%Fx en N 
    C_0=b0;
    C=C_0;
    D=b1*Z^2+b2*Z;
    BCD=(b3*Z^2+b4*Z)*exp(-b5*Z);
    B=BCD/(C*D);
    Fx0=D*sin(C*atan(B*tau));
    %COUPLAGE
    CD=bm0;
    BD=bm2*cos(atan(bm3.*tau));
    der_BD=-bm2*bm3.*sin(atan(bm3.*tau))*1./(1+(bm3.*tau).^2);
    AD=bm1;
    Gx_u=cos(CD*atan(BD*(derive-AD)));
    der_Gx_u=-sin(CD.*atan(BD.*(derive-AD))).*CD.*(1./(1+(BD.*(derive-AD)).^2)).*der_BD.*(derive-AD);
    Gx_v=cos(CD*atan(BD*(-AD)));
    der_Gx_v=-sin(CD.*atan(BD.*(-AD))).*CD.*(1./(1+(BD.*(-AD)).^2)).*der_BD.*(-AD);
    Gx=Gx_u./Gx_v;
%     EFFORT TRANSVERSAUX AVEC COUPLAGE
    Fx=mu.*(Fx0.*Gx);
    
    
    
    %----Mz----%
%-- ENTREES
%angle_derive en °
%Fz en N
%-- SORTIES
    C_0=c0;
    C=C_0;
    D=c1*Z^2+c2*Z;
    BCD=(c3*Z^2+c4*Z)*exp(-c5*Z);
    B=BCD/(C*D);
    Mz=mu.*(D*sin(C*atan(B*derive)));
    
    out=[Fy;Fx;Mz];
end

