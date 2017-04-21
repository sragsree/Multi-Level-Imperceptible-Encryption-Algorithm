clc, clear all;
[m,fs,nbits]=wavread('stego_message.wav');
wavplay(m,fs);
y=((2^(nbits-1)*m(:,1)));
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
  for h=1:16
      k(h)=y(h,nbits-1);
  end
  
  b=bin2dec(k);
 for j=17:b+16
  msg(j)=y(j,nbits-1);
 end
  smsg=[];
  o=8;
 for q=1:8:length(msg)
     smsg=[smsg; msg(1,q:o)];
     o=o+8;
 end
  g=bin2dec(smsg);
   char (g')
 
