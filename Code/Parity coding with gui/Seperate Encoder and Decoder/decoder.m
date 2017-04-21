clc, clear all;
%Decoder
[m,fs,nbits]=wavread('stego_message.wav');
wavplay(m,fs);
%Analog-to-Digital Conversion
y=((2^(nbits-1)*m(:,1)));%change the samples into decimals
%store the sign in most significant bit
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
%check first 16 samples to know how many samples contain secret message
  for h=1:16
      k(h)=y(h,nbits-1);
  end
  
  b=bin2dec(k);
  %extract message
 for j=17:b+16
  msg(j)=y(j,nbits-1);
end
%change the row vector in nx8 matrix
  smsg=[];
  o=8;
 for q=1:8:length(msg)
     smsg=[smsg; msg(1,q:o)];
     o=o+8;
 end
 %check ASCII
  g=bin2dec(smsg);
   mesg=char (g')
   disp(mesg);
 
