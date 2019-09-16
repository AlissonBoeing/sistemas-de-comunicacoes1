%% Presença do ruído:
% Formatando em vários níveis

clear all
close all
clc

% Formatando em mais de 1 nível

N = 100;
M = 2;  % Número de níveis
A = 1; % Amplitude máxima
dist_nivel = 2; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 1000000;

% Informação de entrada
info_bin = randint(1, num_simb*l);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*dist_nivel-A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3
% Filtrando
filtro = ones(1, N);
info_tx = filter(filtro, 1, info_up);

% Gerando o sinal de saída com ruído: 
vari = 2;
mean = 0;
                                                        %outramaneira: Não utilizar vari, utiliza AWGN, relação sinal ruído                                                                          
SNR = 0; %ruido = sqrt(vari)*rand(length(info_tx), 1)+mean;        (dB)
info_rx = awgn(info_tx,SNR); %info_rx = info_tx + ruido;                              %
                                                       
% plotando

subplot(2,1,1);
plot(info_tx)
xlim([0 20*N])
ylim([-4 4])
title('Sinal de transmissao');

subplot(2,1,2);
plot(info_rx)
xlim([0 20*N])
ylim([-5 5])
title('Sinal de recepcao');

limiar = 0;
a = info_rx;

info_hat = a(N/2:N:end) > limiar;

figure(3)


plot(info_hat)
xlim([0 500])


num_erro = sum(xor(info_bin, info_hat));
taxa_erro = num_erro/length(info_bin);
