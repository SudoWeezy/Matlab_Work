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