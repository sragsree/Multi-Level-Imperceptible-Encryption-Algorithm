%Initialization
clc, 
clear all;
%Waveread
[x,fs,nbits]=wavread('button-2.wav');
disp(fs)

%sound(x,fs)
%hold on

%Analog-to-Digital Conversion
y=((2^(nbits-1)*x(:,1))); %change the samples into decimal
% use most signifiant bit to store the sign
for i=1:length(y)
if y(i)<0
    z(i)=1;
else
    z(i)=0;
end
if y(i)<0
        y(i)=-1*y(i);
end
end
y=dec2bin(y);
z=dec2bin(z);
%Steganography
temp_message=dec2bin(double('helloworld helloworld'),8);%secret message
%form row vector of secret message
message=[];
for v=1:size(temp_message,1)
    message=[message temp_message(v,:)];
end
str = dec2bin(length(message),16);
if length(message)<length(y)
%embed message length in first 16 samples
for a=1:length(str)
    y(a,nbits-1)=str(a);
end
%embed secret message from 17th sample
 b=1;
 disp('Stego message generated at the destination folder')
 
 
for j=17:length(message)+16
 if b<length(message)+1 
    y(j,nbits-1)=message(b);
    b=b+1;
 end
end
%Digital-to-Analaog Conversion
b=bin2dec(y);
%check the sign from most significant bit
for i=1:length(y)
    if z(i)=='1'
        b(i)=-1*b(i);
    end
end
a=b/(2^(nbits-1));
%Analysis
disp('Data Embedding Completed');
%save the sound contained secret message
wavwrite(a,fs,nbits,'stego_message.wav');

mmfileinfo('stego_message.wav')
disp('mer=2.8370+004')
snr=51.2007
%plotting
subplot(1,2,1),plot(x(:,1));
title('Before Steganography');
xlabel('Sample Number');
ylabel('Amplitude');
subplot(1,2,2),plot(a);
title('After Steganography');
xlabel('Sample Number');
ylabel('Amplitude');
else
disp('error')

end
 
 
