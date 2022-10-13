%ME 370, FFT program
clear all
close all
clc
format compact

fi = 10;      %input frequency (Hz)
N = 256;      %Number of sample points
fs = 20;      %sampling frequency (Hz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt=1/fs     %time between data points  
T=(N)/fs    %total sample time (T)
t = 0:dt:T; %creates a vector of times to sample y at
t2=0:dt/100:T;
% y = sin(2*pi*fi*t);
% y2=sin(2*pi*fi*t2);
   
% Test
y = 5 + 10*cos(30*t)+15*cos(90*t);
y2 = 5 + 10*cos(30*t2)+15*cos(90*t2);
  

        


Yo=2/T*dt*fft(y(1:end-1));
w=0:(2*pi/(N*dt)):((2*pi/dt) - 2*pi/(N*dt));
w=w - (2*pi/dt).*((w*dt)>pi);
f=w/(2*pi);

figure
r = 2; c = 1;
subplot(r,c,1)
    plot(t,y,'o',t2,y2)

    xlabel('Time (seconds)')
    ylabel('Amplitude')
    title({'Sampled Input Function y(t)',sprintf('f_{s} = %d Hz, f_{i} = %d Hz, N = %d',fs,fi,N)})

    
subplot(r,c,2)
    stem(f,abs(Yo(1:end)),'^') %(1:N/2) modifies vectors so only frequencies
                                %below Nyquist frequency is shown  
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    title('FFT of y')

    axis([0 10^(floor(log10(fi))+1) 0 1.1*max(real(abs(Yo)))])


hold on
