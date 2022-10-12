%ME 370, FFT program
clear all
close all
clc
format compact

fs=105;      %sampling frequency (Hz)
N=120;        %number of samples
fi=10;        %frequency of input data [y=sin(2*pi*w*t] (Hz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt=1/fs     %time between data points
T=(N)/fs  %total sample time (T)

t = 0:dt:T;         %creates a vector of times to sample y at
y = sin(2*pi*fi*t);  %creates a vector of y(t) discrete values

%%%%%%%%%%%%%%%%%%%%%%%% Hanning window %%%%%%%%%%%%%%%%%%%%%
H=hann(N+1);          %creates a Hanning window
Hy=y.*H';           %array multiply (y and H) to create a windowed Hy

Yo=2/T*dt*fft(y(1:end-1));
HYo=2/T*dt*fft(Hy);
w=0:(2*pi/(N*dt)):((2*pi/dt-2*pi/(N*dt)));
w=w - (2*pi/dt).*((w*dt)>pi);
f=w/(2*pi);

figure(1)
clf
subplot(2,2,1)
plot(t,y,'.-')

xlabel('Time (seconds)')
ylabel('Amplitude')
title({'Sampled Input Function y(t)',sprintf('f_{s} = %d Hz, f_{i} = %d Hz, N = %d',fs,fi,N)})
axis([0 max(t) 1.1*min(y) 1.1*max(y)])
subplot(2,2,2)
plot(t,Hy,'.-')
xlabel('Time (seconds)')
ylabel('Amplitude')
title('Hanning window applied to y(t)')
axis([0 max(t) 1.1*min(y) 1.1*max(y)])
subplot(2,2,[3,4]);
stem(f,abs(Yo(1:length(f))),'^','b')
hold on;
grid
stem(f,abs(HYo(1:length(f))),'^','r')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT of y')
axis([0 3*fi 0 1.1*max(real(abs(Yo)))])
legend('FFT(y)','FFT(Hanned(y))')



