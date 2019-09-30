clear all
close all
clc

% Formatando em mais de 1 nível

N = 10000; % Amostras por símbolo
M = 2;  % Número de níveis
A = 1; % Amplitude máxima
dist_nivel = 1; %Distancia entre níveis

% Dados temporais:
t_final = 1; % em segundos
Rb = 1e3; % taxa de transmissão

% Número de bits por nível
l = log2(M);

Rs = Rb/l; % taxa de símbolos
fs = Rb*N; % Frequência de amostragem
t = [0:1/fs:t_final-((1/(Rb*N)))]; % Criando o eixo do tempo



% Informação de entrada
info_bin = [0 1 1 0 1 0 1 1 0 1 0];

% Gerando número de símbolos:
num_simb = length(info_bin);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*dist_nivel-A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3

% Filtrando NRZ ---> Este filtro que será casado depois
filtro_tx = ones(1, N);
info_tx = filter(filtro_tx, 1, info_up);
                                                     
% plotando

figure(1)
plot(info_tx)
xlim([0 20*N])
ylim([-4 4])
title('Sinal na transmissão');
grid

SNRmin = 0;
SNRmax = 10;

limiar_est = 0;

% Variando relação sinal/ruído 
for SNR = SNRmax:SNRmax
    info_rx = awgn(info_tx,SNR);
    info_est = info_rx(N/2:N:end)>limiar_est;
    num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
    taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;
end

% Plotando a taxa de erros:

figure(2)
semilogy([SNRmin:1:SNRmax], taxa_erro);
xlim([0 15])
grid
title('Dependência da Taxa de erro pelo SNR');
xlabel('SNR[dB]');
ylabel('Bit Error Rate');
hold on

% Fazendo o filtro casado ----------------------- MAIS IMPORTANTE DESSA AULA

filtro_rx = fliplr(filtro_tx);

% Variando relação sinal/ruído com filtro
for SNR = SNRmin:SNRmax
    info_rx = awgn(info_tx,SNR, 'measured');
    info_rx_filtered = filter(filtro_rx,1,info_rx)/N; %% Filtrando com o filtro casado
    info_est = info_rx_filtered(N/2:N:end)>limiar_est;
    num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
    taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;
end

% Plotando a taxa de erros:

figure(3);

semilogy([SNRmin:1:SNRmax], taxa_erro);
legend('Sinal recebido', 'Sinal recebido e filtrado');
grid

figure(4);
subplot(3,1,1);
plot(info_tx);
title('Sinal transmitido');
xlim([0 10e-3]);
ylim([-2 2]);
grid

subplot(3,1,2);
plot(info_rx);
title('Sinal na entrada da recepção');
xlim([0 10e-3]);
grid

subplot(3,1,3);
plot(info_rx_filtered);
title('Sinal efetivamente recebido');
xlim([0 10e-3]);
ylim([-2 2]);
grid