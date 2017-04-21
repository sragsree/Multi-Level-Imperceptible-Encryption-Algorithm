clc;
clear all;
close all;

[x,fs]=wavread('button-2.wav');
plot(x)
title('input sound wave');
%disp(x)

% %normalising the vales in a particular range
% min_value=min(x);
% disp('min value is: ')
% disp(min_value);
% max_value=max(x);
% disp('max value is: ')
% disp(max_value);
% new_max=8388607;
% new_min=-(8388608);
% norm=(((x-min_value)/(max_value-min_value))*(new_max-new_min))+new_min;
% figure;
% plot(norm)
% title('after normalization');


new_norm=x+abs(min(x));
%display (new_norm)
scaled_value=round(new_norm.*(((2^24)-1)/max(new_norm)));
figure;
plot(scaled_value)
title('after scaling');

n=size(scaled_value);
scaled_bin=dec2bin(scaled_value,24);
disp(n)
i=1;

  for j=1:210
      for k=1:210
         arr(j,k)=scaled_value(i);
          i=i+1;     
       end
   end
  k=1;
 
ay(:,:,1)=zeros(210,210);
ay(:,:,2)=zeros(210,210);
ay(:,:,3)=zeros(210,210);
   for i=1:210
       for j=1:210
            
           q=arr(i,j);
           q=dec2bin(q,24);
           
           
           q1=q(1:8);
           q2=q(9:16);
           q3=q(17:24);
           q1=bin2dec(q1);
           q2=bin2dec(q2);
           q3=bin2dec(q3);
           ay(i,j,1)=q1;
           ay(i,j,2)=q2;
           ay(i,j,3)=q3;
                    
          
       end
   end
   
figure;
imshow(uint8(ay));
title('Image obtained from signal ');



x1=imread('cameraman.tif');
y1=imresize(x1,[210,210]);
%y=rgb2gray(y);
figure;
imshow(y1);
title('image before hiding');
%disp(y)

  
level = graythresh(y1);
bw = im2bw(y1,level);
%imshow(bw);
% disp(bw)


arry(:,:,1)=zeros(210,210);
arry(:,:,2)=zeros(210,210);
arry(:,:,3)=zeros(210,210);


 


for i=1:210
    for j=1:210
        
        
        ary=y1(i,j);
        %disp(ary)
        
      
         arr=ay(i,j,:);
         % disp(arr)
        
             
              image_value=dec2bin(ary,8);
             
         
              r=image_value(1:3);
              g=image_value(4:6);
              b=image_value(7:8);
             
           
              image_value1=dec2bin(arr(:,:,1),8);
              image_value2=dec2bin(arr(:,:,2),8);
              image_value3=dec2bin(arr(:,:,3),8);
              %disp(image_value1)
              
             
              p=image_value1(1:8);
              q=image_value2(1:8);
              s=image_value3(1:8);
              
            
              p(6:8)=r(1:3);
              q(6:8)=g(1:3);
              s(7:8)=b(1:2);
              
          
        
              p=bin2dec(p);
              q=bin2dec(q);
              s=bin2dec(s);
              
            
              arry(i,j,1)=p;
              arry(i,j,2)=q;
              arry(i,j,3)=s;
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
          
     end
end

%display the embedded image
%disp(arry)
figure;
imshow(uint8(arry));
title('data hided image');


for i=1:210
    for j=1:210
           arry1=arry(i,j,1);
           arry2=arry(i,j,2);
           arry3=arry(i,j,3);
           
           arry1=dec2bin(arry1,8);
           arry2=dec2bin(arry2,8);
           arry3=dec2bin(arry3,8);
            
           d(1:8)=arry1(1:8);
           d(9:16)=arry2(1:8);
           d(17:24)=arry3(1:8);
            
           img_24(i,j)=bin2dec(d);
    end 
end
n=1;
for i=1:210
    for j=1:210
    img_1(n)=img_24(i,j);
    n=n+1;
    end 
end
figure;
plot(img_1)
min_value=min(img_1);
disp('min value is: ')
disp(min_value);
max_value=max(img_1);
disp('max value is: ')
disp(max_value);
new_max=8388607;
new_min=-(8388608);
norm_sgl=(((img_1-min_value)/(max_value-min_value))*(new_max-new_min))+new_min;
wavwrite(norm_sgl,fs,'cccc.wav');
figure;
plot(x)
title('signal after hiding the image');
             

for i=1:210
    for j=1:210
        r1=arry(i,j,1);
        g1=arry(i,j,2);
        b1=arry(i,j,3);
                  
                 
        r2=dec2bin(r1,8);
        g2=dec2bin(g1,8);
        b2=dec2bin(b1,8);

        v(1:3)=r2(6:8);
        v(4:6)=g2(6:8);
        v(7:8)=b2(7:8);
        %disp(v)
        
        %l1=[r1 g1 b1];
        a(i,j)=bin2dec(v);
        %disp(l1)snd)
        
        k=k+1;
    end
end
figure;
imshow(uint8(a));
title('image extracted');




l=max(norm_sgl);
p=min(norm_sgl);
q=(l-p);
disp('max-min')
disp(q)

q_sqr=q*q;
for i=1:44100
    scl=scaled_value(i);
end
u=(norm_sgl-scl);
v_1=size(u);
disp('size')
disp(v_1)
w=0;
w1=0;
for i=1:v_1
    w1=u(i)*u(i);
    w=w+w1;
end
%disp('mean squre error 1')
%w=w/44100;
%disp(w)

g1=(q_sqr/w);
pn1=10*log(g1);
disp('psnr of data hided signal to row signal ')
disp(pn1)


noise=awgn(norm_sgl,10^4,'measured');
% figure;
% plot(noise)
% title('AUDIO WITH HIDDEN IMAGE AFTER ADDING WHITE GAUSSIAN NOISE')

l_1=max(noise);
p_1=min(noise);
q_1=(l_1-p_1);
disp('max-min')
disp(q_1)

q_sqr1=q_1*q_1;
for i=1:44100
    scl1=scaled_value(i);
end
u1=(noise-scl1);
v_2=size(u1);
disp('size')
disp(v_2);
w2=0;
w3=0;
for i=1:v_2
    w2=u1(i)*u1(i);
    w3=w3+w2;
end
%disp('mean squre error 1')
%w3=w3/44100;
%disp(w3)

g2=(q_sqr1/w3);
pn2=10*log(g2);
% disp('psnr of data hided signal with gaussian noise signal ')
% disp(pn2)


dct=dct(y1);
% figure
%imshow(dct);


 


new_img1=zeros(208,208);
new_img2=zeros(208,208);
new_img3=zeros(208,208);
new_img=zeros(208,208);

for i=1:16:208
    for j=1:16:208
        p=1;q=1;
        for k=i:i+15
            for l=j:j+15
                y_1(p,q)=ay(k,l,1);
                y_2(p,q)=ay(k,l,2);
                 y_3(p,q)=ay(k,l,3);
                  y(p,q)=y1(k,l);
                q=q+1;
            end
            p=p+1;
        end
        d_1=dct2(y_1);
        d_2=dct2(y_2);
        d_3=dct2(y_3);
          d=dct2(y);
          
        d_matx1=vec2mat(d_1,16);
        d_matx2=vec2mat(d_2,16);
        d_matx3=vec2mat(d_3,16);
         d_matx=vec2mat(d,16);
        
        d_new1=zeros(16,16);
        d_new2=zeros(16,16);
        d_new3=zeros(16,16);
        d_new=zeros(16,16);
        for k=1:8
            for l=1:8
                d_new1(k,l)=d_matx1(k,l);
                d_new2(k,l)=d_matx2(k,l);
                d_new3(k,l)=d_matx3(k,l);
                 d_new(k,l)=d_matx(k,l);
            end
        end
        new_img1(i:i+15,j:j+15)=d_new1;
        new_img2(i:i+15,j:j+15)=d_new2;
        new_img3(i:i+15,j:j+15)=d_new3;
        new_img(i:i+15,j:j+15)=d_new;
        new_img3(i+8:i+15,j+8:j+15)=new_img(i:i+7,j:j+7);
    end
end
% figure;
% imshow(new_img3);
% title('dct hided image');

for i=1:210
    for j=1:210
        
       
        ary1=abs(dct(i,j));
        %disp(ary)
        
       
         arr=ay(i,j,:);
         % disp(arr)
        
               
              image_value4=dec2bin(ary1,8);
             
            
              rr=image_value4(1:3);
              gg=image_value4(4:6);
              bb=image_value4(7:8);
             
              
              image_value11=dec2bin(arr(:,:,1),8);
              image_value22=dec2bin(arr(:,:,2),8);
              image_value33=dec2bin(arr(:,:,3),8);
              
              
              
              p1=image_value11(1:8);
              q1=image_value22(1:8);
              s1=image_value33(1:8);
              
              
              p1(6:8)=rr(1:3);
              q1(6:8)=gg(1:3);
              s1(7:8)=bb(1:2);
              
          
           
              p1=bin2dec(p1);
              q1=bin2dec(q1);
              s1=bin2dec(s1);
              
             
              arrys(i,j,1)=p1;
              arrys(i,j,2)=q1;
              arrys(i,j,3)=s1;
              
              
          
     end
end

%display the embedded image
%disp(arry)
% figure;
% imshow(uint8(arrys));
for i=1:210
    for j=1:210
           arrys1=arrys(i,j,1);
           arrys2=arrys(i,j,2);
           arrys3=arrys(i,j,3);
           
           arrys1=dec2bin(arrys1,8);
           arrys2=dec2bin(arrys2,8);
           arrys3=dec2bin(arrys3,8);
            
           d1(1:8)=arrys1(1:8);
           d1(9:16)=arrys2(1:8);
           d1(17:24)=arrys3(1:8);
            
           img1_24(i,j)=bin2dec(d1);
    end 
end
n1=1;
for i=1:210
    for j=1:210
    img_2(n1)=img1_24(i,j);
    n1=n1+1;
    end 
end



% min_value1=min(img_2);
% disp('min value is: ')
% disp(min_value);
% max_value1=max(img_2);
% disp('max value is: ')
% disp(max_value);
% new_max=8388607;
% new_min=-(8388608);
% norm_sgl1=(((img_2-min_value1)/(max_value1-min_value1))*(new_max-new_min))+new_min;
% figure;
% plot(norm_sgl1)
% title('signal after hiding the DCT of image');

% l_2=max(norm_sgl1);
% p_2=min(norm_sgl1);
% q_2=(l_2-p_2);
% disp('max-min')
% disp(q_2)
% 
% q_sqr2=q_2*q_2;
% for i=1:44100
%     scl1=scaled_value(i);
% end
% u2=(norm_sgl1-scl1);
% v_3=size(u2);
% disp('size')
% disp(v_3)
% w4=0;
% w5=0;
% for i=1:v_3
%     w4=u2(i)*u2(i);
%     w5=w5+w4;
% end
% %disp('mean squre error 1')
% %w3=w3/44100;
% %disp(w3)
% 
% g3=(q_sqr2/w5);
% pn4=10*log(g3);
% disp('psnr of data hided signal -DCT ')
% disp(pn4)
