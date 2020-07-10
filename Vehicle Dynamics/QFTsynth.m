
s=tf('s');

for ind=1:16
    P(1,1,ind)=Gtest(ind);
end

%freq=[0.01,0.1,0.3,1,2,5,10,30,100,1000];
save plant.mat P

%%

figure
subplot(2,2,1),bodemag(K*G/(1+K*G))
Q=max(bode(K*G/(1+K*G)))
title('T');
subplot(2,2,2),bodemag(1/(1+K*Gn))
title('S');
subplot(2,2,3),bodemag(K/(1+K*Gn))
title('KS');
subplot(2,2,4),bodemag(Gn/(1+K*Gn))
title('GS');


figure
subplot(2,2,1),step(K*G/(1+K*G))
D=max(step(K*Gn/(1+K*G)))
title('T');
subplot(2,2,2),step(1/(1+K*G))
title('S');
subplot(2,2,3),step(K/(1+K*G))
title('KS');
subplot(2,2,4),step(Gn/(1+K*G))
title('GS');

%%
