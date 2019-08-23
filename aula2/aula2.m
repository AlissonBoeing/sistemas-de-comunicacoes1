fs = 300e3;
t = 0:1/fs:1;

f1 = 100;
f2 = 200;
f3 = 300;

y1 = 10*cos(2*pi*f1.*t);
y2 = cos(2*pi*f2.*t);
y3 = 4*cos(2*pi*f3.*t);

yt = y1 + y2+ y3;

subplot(5,1,1)
plot(t,yt);
xlim([0 0.1])
xlabel('Tempo')

subplot(5,1,2);
Yt = fft(yt);
Y1 = fftshift(Yt)/length(Yt);
f = [-fs/2:fs/2];
plot(f,abs(Y1));
xlim([-500 500])
xlabel('Frequencia');

 filtro_PB = [zeros(1,149850) ones(1,301) zeros(1,149850)];

aposfiltro = abs(Y1).*filtro_PB;

subplot(5,1,3);
plot(f,filtro_PB);
axis([-1000 1000 0 1.5]);
xlabel('Filtro');


subplot(5,1,4);
plot(f,aposfiltro);
xlim([-1000 1000]);
xlabel('Espectro apos filtro');

s_t_hat = ifft(ifftshift(aposfiltro)) * length(Yt);



subplot(5,1,5);
plot(t, s_t_hat);
xlabel('Sinal apos filtro');
%Y = fft(y);
%Y1 = fftshift(Y);
%subplot(1,2,1);
%plot(abs(Y));
%subplot(1,2,2);
%f = [-50e3:1e2:50e3];
%plot(f,abs(Y1));