%auhide
%Author:Ankur Pawar
%Description: Steganography in wav file using lsb method
%Date of creation :19 Nov 2009
%sample file:new2.wav
[filename, pathname] = uigetfile('*.wav','Select a file');        
[y,fs,nbits,opts]=wavread([pathname filename],[1 2]);

%open a wav file for hidding text
fid1=fopen([pathname filename],'r');

%first 40 bytes make wav header,store the header
header=fread(fid1,40,'uint8=>char'); 

%41st byte to 43rd byte,length of wav data samples 
data_size=fread(fid1,1,'uint32');

%copy the 16 bit wav data samples starting from 44th byte
[dta,count]=fread(fid1,inf,'uint16');   

%close the file only wav data samples are sufficient to hide the text 
fclose(fid1);

lsb=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg='Hello how are you?';      %text message    %%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run aurecover.m to recover this message from new2.wav file



msg_double=double(msg);       %convert it to double
msg_bin=de2bi(msg_double,8);  %then convert message to binary
[m,n]=size(msg_bin);          %size of message binary
msg_bin_re=reshape(msg_bin,m*n,1);  %reshape the message binary in a column vector   
m_bin=de2bi(m,10)';
n_bin=de2bi(n,10)';
len=length(msg_bin_re);       %length of message binary 
%len=m*n

len_bin=de2bi(len,20)';       %convert the length to binary
                              
%hide identity in first 8 wav data samples.
identity=[1 0 1 0 1 0 1 0]';
dta(1:8)=bitset(dta(1:8),lsb,identity(1:8));

%hide binary length of message from 9th to 28 th sample 
dta(9:18)=bitset(dta(9:18),lsb,m_bin(1:10));
dta(19:28)=bitset(dta(19:28),lsb,n_bin(1:10));                              

%hide the message binary starting from 29th position of wave data samples
dta(29:28+len)=bitset(dta(29:28+len),lsb,msg_bin(1:len)');

%open a new wav file in write mode
fid2=fopen('new2.wav','w');

%copy the header of original wave file
fwrite(fid2,header,'uint8');
fwrite(fid2,data_size,'uint32');

%copy the wav data samples with hidden text
fwrite(fid2,dta,'uint16');
fclose(fid2);
