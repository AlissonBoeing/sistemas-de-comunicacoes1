clear all
close all
clc

Fs = 44.1e3;
f1 = 1e3;
k = 3;
L = 2^k;
A = 1;
%t = [0:1/Fs:3/f1];
t = [0:1/Fs:5];
y = A*cos(2*pi*f1*t);
passo_q = (2*A)/L;
x = (y + A)-(passo_q/2);
y_quant = x/passo_q;
y_quant = round(y_quant);
y_quant = y_quant(2:end);
y_unquant=(y_quant*passo_q)-A;
Y = fftshift(fft(y));
Y_un = fftshift(fft(y_unquant));
f = [-Fs/2:1/5:Fs/2];
filtro = fir1(10, (2*1500)/Fs);
y_filter = filter(filtro, 1, y_unquant);
Y_filter = fftshift(fft(y_filter));
figure(1)
plot(t(2:end),y_unquant)
ylim([A*-1.5 A*1.5])
xlim([0 2/f1])
hold on
plot(t(2:end), y(2:end))
xlim([0 2/f1])
hold on
plot(t(2:end), y_filter)

figure(2)
subplot(311)
plot(f(2:end),abs(Y(2:end)))
subplot(312)
plot(f(2:end), abs(Y_un))

subplot(313)
plot(f(2:end), abs(Y_filter))


