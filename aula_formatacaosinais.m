%% Formatando sinal

clc
clear all;
close all

% sinal de informação
info = [0 1 1 0 1];

% tamanho da superamostragem
n = 100;

% superamostrando info:
info_up = upsample(info, n);

% gernado o filtro: NRZ
filtro_NRZ = ones(1,n);

% Gerando a onda formatada:
info_tx = filter(filtro_NRZ, 1, info_up);

% plotando
subplot(2,1,1);
plot(info_up);
title('Sinal pré formatação');
ylim([0 2]);

subplot(2,1,2);
plot(info_tx)
title('Sinal formatado');
ylim([0 2]);

% plotando em Stem
figure(2)
subplot(2,1,1);
stem(info_up);
title('Sinal pré formatação');
ylim([0 2]);

subplot(2,1,2);
stem(info_tx);
title('Sinal formatado');
ylim([0 2]);

%% Formatando em vários níveis

clear all
close all
clc

% Formatando em mais de 1 nível

N = 100;
% Número de níveis
M = 4;
A = 3; % Amplitude máxima
dist_nivel = 2; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 500;

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

% plotando
plot(info_tx)
xlim([0 20*N])
ylim([-4 4])

%% Presença do ruído:

% Formatando em vários níveis

clear all
close all
clc

% Formatando em mais de 1 nível

N = 100;
M = 2;  % Número de níveis
A = 3; % Amplitude máxima
dist_nivel = 4; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 500;

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
ruido = sqrt(vari)*rand(length(info_tx), 1)+mean;       %SNR = 10; (dB)
info_rx = info_tx + ruido;                              %info_rx = awgn(info_tx,SNR);
                                                       
% plotando

subplot(2,1,1);
plot(info_tx)
xlim([0 20*N])
ylim([-4 4])
title('Sinal');

subplot(2,1,2);
plot(info_rx)
xlim([0 20*N])
ylim([-5 5])
title('Sinal com ruído');