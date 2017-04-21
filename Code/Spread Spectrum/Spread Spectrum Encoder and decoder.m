
clear;clc; 
N=1024;
Fs=22050;
len=1000;

r = audiorecorder(Fs, 16, 1);
h = waitbar(0,'Recording Audio .... ');
       record(r);     
       for i=1:5000
           n=i+1;
           waitbar(i/5000,h)
       end
      
       waitbar(1,h,'Finish');
        close (h);
         stop(r);
    % p = play(r)     
    
    mySpeech = getaudiodata(r, 'uint8'); 
    mySpeech2 = getaudiodata(r, 'double');
    
    
    
    wavplay(mySpeech,22050)
    wavwrite(mySpeech2,22050,'Originalrekam2.wav'); 
    re=wavread('Originalrekam2.wav');
    plot(re);
    title('Recorded audio');
    figure;
    plot(mySpeech)
    title('After hiding the text');

    Ori = mySpeech;


    [x,y] = size(Ori)
    p=ceil(sqrt(x))
    Atemp=zeros(1,p^2);
    Atemp(1:x) = Ori(1:x,1)';
    for i=1:p
        Ori2(i,1:p)= Atemp((i-1)*p+1:p*i);
    end
    size(Ori2)
   % Ori2


    [U,S,V] = svd(Ori2);




%     [a,b] = size(S);
%      reg = eye(a,b);
%     reg1 = (S+reg)*10000;
% %    Db  = dec2bin(reg1);
%     reg2 = uint16(reg1);
 
    reg2=ceil(S);
    % [xreg,yreg]=size(reg2)


    fid = fopen('message.txt');
    message = fread(fid);
    fclose(fid);

    message = dec2bin(message);
    [a,b]   = size(message);
    for i=1:a,
        Mess((i-1)*b+1:i*b) = message(i,:);
    end
    Mess
    [xmess,ymess]=size(Mess)
%     


      [p,q]=size(reg2);
% 

    r   = ceil(a*b/p);
    F15 = uint8(zeros(r,q));
    Mess(r*q) = 0;
    for i=1:r,
        F15(i,1:q) = Mess((i-1)*q+1:i*q);
    end
    F15 = (F15-48);%*64;
    F15(p,q) = 0;
    
    [xF15,yF15]=size(F15)
    
n = 1; 


Stego = bitxor(uint16(reg2),uint16(F15));
NewStego = double(Stego);
% mengembalikan svd

   % NewStego = (double(Stego)/10000)-eye(p,q);
    Bck = U*NewStego*V';
    [x,y] = size(Bck);
    for i= 1:x
        Hsl((i-1)*x+1:x*i)=Bck(i,1:x);
    end
         wavplay(uint8(Hsl),22050)
  
    Extracted=bitxor(Stego,uint16(reg2));
    Extract = (Extracted);%/64);
    %pusing2=num2str(Extract);
    %F15(p,q) = 0;

    [xExtract,yExtract] = size(Extract)
    panjang = xExtract*yExtract;
    n=1;o=1;
    for i=1:panjang
        nilaimessage(1,i) = Extract(n,o);
        o=o+1;
        if mod(i,xExtract)== 0
            n=n+1;
            o=1;
        end
    end
     nilaimessage2=num2str(nilaimessage);
     nilaimessage2=strrep(nilaimessage2,' ','');
    % message=char(nilaimessage)
    %     for i=1:length(nilaimessage)
    %         message(i,:) = char(i:8)
    p=7;
    [x,y]=size(nilaimessage2);
    end1=ceil(y/7)
    message='';
    for i=1:9000
        sampah= nilaimessage2((i-1)*p+1:p*i);
        message = strcat(message,char(bin2dec(sampah)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    message
    
    len=length(message);
    disp('Length of message = ')
    disp(len)
    BER=(15/len)
    