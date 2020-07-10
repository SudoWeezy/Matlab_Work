%%
close all 
figure(3)
subplot(3,1,1)
plot(WRt);
title('Vitesse de rotation de la roue');grid;
xlabel('Temps(s)');
ylabel('Vitesse angulaire(rd/s)');
subplot(3,1,2)
plot(FXt);
title('Effort longitudinale');grid;
xlabel('Temps(s)');
ylabel('Force(N)');
subplot(3,1,3)
plot(VXt);
title('Vitesse longitudinale');grid;
xlabel('Temps(s)');
ylabel('Vitesse(m/s)');
%%
figure(4)
plot(WRt1);
title('écart échelon');grid;
%%
figure(5)
plot(Perturbation_vent);
xlabel('Temps(s)');
ylabel('Vitesse(m/s)');
title('Perturbation du vent fx0');grid;
%%
figure(5)
plot(Perturbation_alpha);
xlabel('Temps(s)');
ylabel('Angle(rd)');

%%
sim('DVsimulink.slx');
figure(5)

plot(VXt);
hold on
xlabel('Temps(s)');
ylabel('Vitesse(m/s)');
title('Vitesse longtudinale')
%%
grid;
%%
sim('DVsimulink.slx');
figure(6)

plot(Couple);
hold on
xlabel('Temps(s)');
ylabel('Couple(N/s)');
title('Commande du couple à la roue')
grid;
%%
plot(WRt);
hold on
%%
grid;
plot(WRt);
xlabel('Temps(s)');
ylabel('witesse angulaire (rd/s)');
title('vitesse angulaire')
legend('Sans régulateur','QFT')
%%
i=0;
Value=0;
for i=0:8
Value=Value+0.01;
sim('DVsimulink.slx');
figure(6)
plot(WRt1,'-r');hold on
plot(WRt,'-.b');
legend('Modèle linéarisé','Modèle non linéaire')
end
xlabel('Temps(s)');
ylabel('Vitesse angulaire (rd/s)');
title('Réponses indicielles');grid;