clear all;
close all;
%导入时域输入和输出数据，经过快速傅里叶变换fft得到频域幅值和相位
%load Af;%幅值比 Y(w)/U(w)
%load ph_e;%相位差 ∠Y(w)-∠U(w)


%最大幅值Amptitude
Am=8000;
kk=0;
%离散频率步进
for F=1:0.5:45
    kk=kk+1;
    FF(kk)=F;
end
mag_e1=Af/Am;   %幅频 ratio
ph_e1=(-ph_e)*pi;   %相频  rad

%欧拉公式
hp=mag_e1.*(cos(ph_e1)+j*sin(ph_e1)); %频率特性复数表示
na=1;
nb=0;
w=2*pi*FF;   %离散频率点
W=w';
[bb,aa]=invfreqs(hp,w,nb,na);
G=tf(bb,aa);  %求传递函数
[mag,phase,W]=bode(3.514,[1,20.62],w);  %返回拟合后的返回幅度、相位、频率向量
magdB = 20*log10(mag);    %db
[mag111,phase111,W]=bode(48,aa,w);  %返回拟合后的返回幅度、相位、频率向量
magdB111 = 20*log10(mag111);    %db
Mag_e1=20*log10(mag_e1);
Ph_e1=ph_e1*180/pi;    %deg
figure(2);
subplot(2, 1, 1);
semilogx(FF, magdB, '-',FF,Mag_e1,'--');   %对数函数图
subplot(2, 1, 2);
semilogx(FF, phase, '-',FF,Ph_e1,'--');
legend('estimate model','practical model');