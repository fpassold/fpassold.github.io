pwd
ans =
    '/Volumes/Data/Users/fernandopassold/Documents/UPF/Controle_2/6_Usando_RL_Projetos/exercicios'
G2=tf(80, poly([-8 -5 -2]));
zpk(G2)

ans =
 
         80
  -----------------
  (s+8) (s+5) (s+2)
 
Continuous-time zero/pole/gain model.

% opção 2...
G_lead=tf([1 4],[1 12]);
ftma_lead=G_lead*G;
{Undefined function or variable 'G'.} 
ftma_lead=G_lead*G2;
rlocus(ftma_lead)
% calculando posição desejada para os pólos de MF
OS=20;
ts=1.1;
zeta=(-log(OS/100))/(sqrt(pi^2+(log(OS/100)^2)))
zeta =
    0.4559
wn=4/(zeta*ts)
wn =
    7.9754
wd=wn*sqrt(1-zeta^2)
wd =
    7.0981
% wd = parte imaginária dos pólos de MF
sigma = wn*zeta
sigma =
    3.6364
% montando vetor dos pólos de MF
polos_mf=[-sigma+i*wd -sigma-i*wd]
polos_mf =
  -3.6364 + 7.0981i  -3.6364 - 7.0981i
figure(1) % foco do RL anterior
hold on
plot(polos_mf,'r+')
help sgrid
 <strong>sgrid</strong>  Generate s-plane grid lines for a root locus or pole-zero map.
    <strong>sgrid</strong> generates a grid over an existing continuous s-plane root
    locus or pole-zero map.  Lines of constant damping ratio (zeta)
    and natural frequency (Wn) are drawn.
 
    <strong>sgrid</strong>('new') clears the current axes first and sets HOLD ON.
 
    <strong>sgrid</strong>(Z,Wn) plots constant damping and frequency lines for the 
    damping ratios in the vector Z and the natural frequencies in the
    vector Wn.
 
    <strong>sgrid</strong>(Z,Wn,'new') clears the current axes first and sets HOLD ON.
 
    See also <a href="matlab:help rlocus">rlocus</a>, <a href="matlab:help pzmap">pzmap</a>, and <a href="matlab:help zgrid">zgrid</a>.

sgrid(zeta,wn)
[K_Lead,aux]=rlocfind(ftma_lead)
Select a point in the graphics window
selected_point =
  -3.3842 + 6.6729i
K_Lead =
    7.7172
aux =
 -16.9761 + 0.0000i
  -3.0687 + 6.5241i
  -3.0687 - 6.5241i
  -3.8864 + 0.0000i
% testando o lead...
ftmf_lead=feedback(K_Lead*ftma_lead, 1);
figure; step(ftmf_lead)
% ts=1,22; %OS=19.3%
% calculando erro em regime permanente do Lead
(1-dcgain(ftmf_lead)/1)*100
ans =
   27.9925
% iniciando projeto do Lag (para baixar o erro)
% mas reduzindo um pouco o ganho do Lead
% com o objetivo de baixar o ts do Lead
K_Lead=5;
% testando em quanto ficou ts com este ganho
ftmf_lead=feedback(K_Lead*ftma_lead, 1);
figure; step(ftmf_lead)
% com este valor de ganho:
% ts(Lead)=0,964; y(\infty)=0,625 -- isto é, o erro aumentou
% Definindo o Lag
C_Lag=tf([1 6],[1 3])

C_Lag =
 
  s + 6
  -----
  s + 3
 
Continuous-time transfer function.

ftma_lead_lag=C_Lag*G_lead*G2;
% RL final
figure; rlocus(ftma_lead_lag)
hold on
plot(polos_mf,'m+')
% Realizando um ajuste no Lag...
C_Lag=tf([1 10],[1 3]) % afastando o zero do Lag...

C_Lag =
 
  s + 10
  ------
  s + 3
 
Continuous-time transfer function.

ftma_lead_lag=C_Lag*G_lead*G2;
% verificando como ficou o RL...
figure; rlocus(ftma_lead_lag)
hold;
Current plot held
hold on;
plot(polos_mf,'m+')
sgrid(zeta,wn)
figure(4);
sgrid(zeta,wn)
K_lead_lag=1.85;
ftmf_lead_lag=feedback(K_lead_lag*ftma_lead_lag, 1);
figure;
step(ftmf_lead_lag)
diary off
