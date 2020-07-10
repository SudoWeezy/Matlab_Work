clear all 
close all 
clc
%p=tf('p');
syms c eta mu ba brr br K J m r0 rho w v u a1 a2 a3 a4 p
A=[[(c*mu-ba-brr)/m c*eta/m];...
    (-r0*c*mu)/J (-r0*c*eta-br)/J];

B=[0;K];
C=[0 1];
D=[0];
X=[v;w];
U=[u];

%%
G=ss2sym(A,B,C,D)
A=[[a1 a2];...
    a3 a4];
G=ss2sym(A,B,C,D)
%%

