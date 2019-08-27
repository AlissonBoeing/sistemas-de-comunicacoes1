%% descrevendo 1 segundo de sinal com distribuicao o gaussiana

fs = 10e3;
t = 0:1/fs:1;
s = randn(1,length(t)); % 1s ruido branco
figure(1);
subplot(221);
plot(t, s);
title('Ruido branco');
xlabel('t');

%% transformada do sinal
sf = fft(s);
sf = fftshift(s)/length(s);

subplot(222)
f = [-fs/2:fs/2];
plot(f,sf);
title('Ruido branco');
xlabel('f');

subplot(223);
hist = histogram(s);
xlabel('t');
xlim([-5 5]);
title('Distribuicao do ruído branco');

%% autocorrelacao do sinal
r = xcorr(s)/length(s);
subplot(224);
plot(r);
title('Autocorrelacao do sinal');
xlim([0 20000]);

%% filtro passa baixa
filtro=fir1(50,(1000*2)/fs);
figure(2);
freqz(filtro); % resposta em freq

figure(3);
x = filter(filtro,1,s); 

subplot(211);
plot(t,x);
title('Sinal apos o filtro no dominio do tempo');
xlabel('t');

%%  transformada
y = fft(x);
Y = fftshift(y)/length(y);
subplot(212);
plot(f,Y);
title('Sinal apos o filtro no dominio da frequencia');
xlabel('f');