%%
clear all;
%处理传感器数据
%加载激励信号
fL=2000*20;
start=71000;
load('D:\Scientific_Research\Zikky\zky20210313\acc_no_change\burst_random_20s20_2kHz\1-4(CH4).mat');
x=Data0(start:start+fL*8-1,1);
%加载响应信号
load('D:\Scientific_Research\Zikky\zky20210313\acc_no_change\burst_random_20s20_2kHz\1-3(CH3).mat');
y=Data0(start:start+fL*8-1,1);

fs=2000;
L=521000;
%%
%构建半矩形与半余弦组合窗,半矩形时长为激励时长，半余弦时长为自由衰减时长
burst_time=20;
burst_percent=20;
sample_time=2000;
win_L=burst_time*sample_time;
win=zeros(burst_time*sample_time,1);
rec_L=win_L*(burst_percent/100);
DT=pi/(win_L/sample_time-rec_L/sample_time);
for i = 1:win_L
    if i<= rec_L
        win(i,1)=1;
    else
        win(i,1)=0.5+0.5*cos(DT*(i/sample_time-rec_L/sample_time));
    end
end
%%
% wind=hann(L/2);
% wind=fL;
% [frf,f]=modalfrf(x,y,fs,wind,'sensor','acc');
modalfrf(x,y,fs,win,'sensor','acc');
%%
% [frf,f] = modalfrf(x,y,fs,fL,'Estimator','subspace','Order',100);
modalsd(frf,f,fs,'MaxModes',50);

%%
%fft
Fs=2000;
T=1/Fs;
L=40000;
t=(0:L-1)*T;
X=win;
Y=fft(X);
p2=abs(Y/L);
p1=p2(1:L/2+1);
p1(2:end-1)=2*p1(2:end-1);
f=Fs*(0:(L/2))/L;
plot(f,p1);
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)')
ylabel('|P1(f)|')


