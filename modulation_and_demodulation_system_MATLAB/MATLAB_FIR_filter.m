%时域图分辨率较差，主要观察频域图滤波前后的变化
%调制参考了https://www.jianshu.com/p/bb7291448a9f中描述的方法
Ka=0.1;
A0=0;
Fs=48000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%基波信号的生成%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Am = 1;
fa = 1000;
Ts = 1/Fs;
t = 0:Ts:0.01;
ym = Am*sin(2*pi*fa*t);
figure(1);
subplot(2,1,1);
plot(t,ym);
title('Fundamental signal');
[YfreqDomain,frequencyRange] = centeredFFT(ym,Fs);
subplot(2,1,2)
stem(frequencyRange,abs(YfreqDomain));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%载波信号的生成%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ac = 1;
fc = fa*10;
Tc = 1/fc;
yc = Ac*sin(2*pi*fc*t);
figure(2)
subplot(2,1,1);
plot(t,yc);
title('Carrier signal');
[YfreqDomain,frequencyRange] = centeredFFT(yc,Fs);
subplot(2,1,2)
stem(frequencyRange,abs(YfreqDomain));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%生成调制信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = Ac*(A0 + Ka*ym).*yc;figure(3)
subplot(2,1,1);
plot(t,y);
title ( 'Amplitude Modulated signal');
[YfreqDomain,frequencyRange] = centeredFFT(y,Fs);
subplot(2,1,2)
stem(frequencyRange,abs(YfreqDomain));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%对调制信号解调%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=y.*yc;
figure(4);
subplot(2,1,1);
plot(t,z);
title ( 'Amplitude deModulated signal');
[YfreqDomain,frequencyRange] = centeredFFT(z,Fs);
subplot(2,1,2);
stem(frequencyRange,abs(YfreqDomain));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%滤波器产生%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%matlab直接滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
re_signal = filter(Num,1, z);
figure(5)
subplot(2,1,1);
plot(t,re_signal);xlabel('filtered signal aftre demodulated');%得到滤波后的图像
[YfreqDomain,frequencyRange] = centeredFFT(re_signal,Fs);
subplot(2,1,2)
stem(frequencyRange,abs(YfreqDomain));
%%%%%%%%%%%%%%%%%%%%%%%%%%%生成浮点数转定点数的文件%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal = round(z * 2^14);
coef = round(Num * 2^16);
figure(6);
subplot(211);plot(t,signal);xlabel('signal input');
f = fopen('input.txt' , 'w');
fprintf(f ,'%g\n' , signal');
fclose(f);
%%%%%%%%%%%%%%%%%%%%%%%%%%生成写入vivado的补码文件%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal_trans2c = dec2bin(signal + 2^16 * (signal<0) , 16);
signal_trans2c = signal_trans2c';
fdata = fopen('input.mem' , 'wb');
for index = 1:length(signal)
    for i = 1:16
       fprintf( fdata ,'%s' , signal_trans2c((index-1) * 16 + i)); 
    end
    fprintf(fdata , '\r\n'); % entering a enter and new a line
end
fclose(fdata);
%%%%%%%%%%%%%%%%%%%%%%%%%%读入滤波后的数据文件并进行可视化%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen('G:\vivado\Free_Design\Free_Design.sim\sim_1\behav\xsim\dataout1.txt');
a = textscan(fid, '%d');%以十进制方式读入
fclose(fid);
figure(7);
subplot(211);
plot(a{1}(6:end));xlabel('The result of physical FIR');
[YfreqDomain,frequencyRange] = centeredFFT(a{1}(6:end),Fs);
