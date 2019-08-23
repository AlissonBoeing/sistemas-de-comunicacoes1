%% Sinais no dominio do tempo
fs = 300e3;
t = 0:1/fs:1;

A1 = 5;
A2 = 5/3;
A3 = 1;

f1 = 1e3;
f2 = 3e3;
f3 = 5e3;

s1 = A1*cos(2*pi*f1.*t);
s2 = A2*cos(2*pi*f2.*t);
s3 = A3*cos(2*pi*f3.*t);

S = s1 + s2 + s3;

figure(1);
subplot(421);
plot(t, s1);
xlim([0 0.01]);
ylabel('s1(t)');
xlabel('t')

subplot(423);
plot(t, s2);
xlim([0 0.01]);
ylabel('s2(t)');
xlabel('t')

subplot(425);
plot(t, s3);
xlim([0 0.01]);
ylabel('s3(t)');
xlabel('t')

subplot(427);
plot(t, S);
xlim([0 0.01]);
ylabel('S(t)');
xlabel('t')

%% Sinais para lista da frequência

%s1
s1f = fft(s1);
S1F = fftshift(s1f)/length(s1f);

s2f = fft(s2);
S2F = fftshift(s2f)/length(s2f);

s3f = fft(s3);
S3F = fftshift(s3f)/length(s3f);

sf = fft(S);
SF = fftshift(sf)/length(sf);


f = [-fs/2:fs/2];

subplot(422);
plot(f,abs(S1F));
xlim([-10e3 10e3])
ylim([0 3])
xlabel('f')
ylabel('s1(f)')

subplot(424);
plot(f,abs(S2F));
xlim([-10e3 10e3])
ylim([0 3])
xlabel('f')
ylabel('s2(f)')

subplot(426);
plot(f,abs(S3F));
xlim([-10e3 10e3])
ylim([0 3])
xlabel('f')
ylabel('s3(f)')


subplot(428);
plot(f,abs(SF));
xlim([-10e3 10e3])
ylim([0 3])
xlabel('f')
ylabel('S(f)')

%% Filtros ideais

filtro_PB = [zeros(1,149000) ones(1,2e3+1) zeros(1,149000)];

figure(2)
subplot(311)
f = [-fs/2:fs/2];
plot(f,filtro_PB);
axis([-2000 2000 0 1.5]);
xlabel('Filtro');

filtro_PB = [zeros(1,149000) ones(1,2e3+1) zeros(1,149000)];

subplot(311)
f = [-fs/2:fs/2];
plot(f,filtro_PB_2);
axis([-2000 2000 0 1.5]);
xlabel('Filtro');