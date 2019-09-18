%% Presença do ruído:
% Formatando em vários níveis

clear all
close all
clc

% Formatando em mais de 1 nível



N = 100; %amostras por simbolo
M = 2;  % Número de níveis
t_final = 5; %tempo final seg
Rb = 1e3; %taxa de transmissao
Rs = log2(M)/Rb; %taxa de simbolo
t = [0:(1/(Rb*N)):t_final];
fs = Rb*N;

A = 1; % Amplitude máxima
dist_nivel = 2; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 100000;

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

filtro2 = fir1(40, ((2*10e3)/fs));



% Gerando o sinal de saída com ruído: 
vari = 2;
mean = 0;
                                                        %outramaneira: Não utilizar vari, utiliza AWGN, relação sinal ruído                                                                          

SNR_min = 0; %ruido = sqrt(vari)*rand(length(info_tx), 1)+mean;        (dB)
SNR_max = 15;
SNR_vec = [SNR_min:SNR_max];

for SNR = 0:15
    info_rx = awgn(info_tx,SNR, 'measured'); %info_rx = info_tx + ruido;                              %
    
    limiar = 0;
    a = info_rx;
    
    info_hat = a(N/2:N:end) > limiar;
    
    num_erro(SNR +1) = sum(xor(info_bin, info_hat));
    taxa_erro(SNR + 1) = num_erro(SNR+1)/length(info_bin);
end




for SNR = 0:15
    info_rx2 = awgn(info_tx,SNR, 'measured'); %info_rx = info_tx + ruido;    %
    filtraruido = filter(filtro2, 1, info_rx2);
    limiar = 0;
    a2 = filtraruido;
    
    info_hat2 = a2(N/2:N:end) > limiar;
    
    num_erro2(SNR +1) = sum(xor(info_bin, info_hat2));
    taxa_erro2(SNR + 1) = num_erro2(SNR+1)/length(info_bin);
end



figure(2)
semilogy(SNR_vec, taxa_erro)
xlabel('SNR')
ylabel('taxa erro')
hold on
semilogy(SNR_vec, taxa_erro2)
%xlabel('SNR')
%ylabel('taxa erro')




% plotando
figure(3)
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



figure(4)


plot(info_hat)
xlim([0 500])

