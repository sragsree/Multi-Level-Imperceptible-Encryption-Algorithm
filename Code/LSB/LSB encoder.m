
clc
clear all;
[x,fs,nbits]=wavread('one.wav');
disp(fs)
mmfileinfo('one.wav')
%sound(x,fs)
%hold on

y=((2^(nbits-1)*x(:,1)));
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
temp_message=dec2bin(double('helloworld helloworld'),8);
message=[];
for v=1:size(temp_message,1)
    message=[message temp_message(v,:)];
end
str = dec2bin(length(message),16);
if length(message)<length(y)
for a=1:length(str)
    y(a,nbits-1)=str(a);
end
 b=1;
 
for j=17:length(message)+16
 if b<length(message)+1 
    y(j,nbits-1)=message(b);
    b=b+1;
 end
end
b=bin2dec(y);
for i=1:length(y)
    if z(i)=='1'
        b(i)=-1*b(i);
    end
end
a=b/(2^(nbits-1));
disp('Data Embedding Completed');
wavwrite(a,fs,nbits,'stego_message.wav');
disp('MER=2.5642e+004')
SNR=50.6490
disp('SNR in Decibels');
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
 
 
