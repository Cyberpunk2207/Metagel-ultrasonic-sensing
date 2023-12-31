clear;
load('Metagel.mat');
num_rec=3000; %Data length
d1=50;
d2=300;
fs=5*10^7;  %Sampling frequency
Ts=1/fs;%Ts——Sampling interval
N0=2*10^5;

L0=100000; 

ya=(zeros(1,L0))';% Number of zero padding

aa=1;
window=10;
interval=0;
freqstart=190000; freqstop=210000;freqstart1=5000; freqstop1=15000; % set of frequency window 
dia_u1=zeros(20,1);
N2=(L0+d2-d1+1)*(window+1);%N ——Number of points
n2=0:N2-1;
f2=n2*fs/N2;%f ——Frequency
while (interval*(aa-1)+window*(aa+1))<num_rec
     siga=([]);
     for m0=interval*(aa-1)+window*aa:1:interval*(aa-1)+window*(aa+1) 

% ************************************************         
     sigm=RF_3D(d1:d2,m0,10);  %sigm=RF_3D(:,m0,n) No.N scanning line
% ************************************************

     sigm=[sigm;ya];    %Zero padding
     siga=[siga;sigm];  %Signal superposition
     end
    sigrec=siga';
    clear siga
    clear recup


 %% FFT--------回波参数设定--------
    Xrec=fft(sigrec,N2);
    ampl2=abs(Xrec);
    frec=f2;
    amplrec=ampl2(freqstart:freqstop);
    [ecoup,ecodown] = envelope(amplrec,230,'peak');
    recup=ecoup;
    clear ecoup
    
%% 找频谱峰位置
    [m,l]=max(recup(freqstart1:freqstop1));
   dia_u1(aa,:)=l+freqstart1+freqstart;  
    freqstop1=freqstart1+l+400;%
    freqstart1=freqstart1+l-400;%
   clear l
   clear m
   clear n

     aa=aa+1;            
    
end
    
  spectral_resolution=fs/N2;
reflec1=dia_u1*fs/N2;   %Frequency calculation
figure();plot(reflec1(:,1),'r');

