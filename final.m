clc;
clear all;
close all;
warning off
[filename,pathname]=uigetfile('*.jpg;*.jpeg;*.gif','Chose original File');
I = imread(cat(2,pathname,filename));
[filename,pathname]=uigetfile('*.jpg;*.jpeg;*.gif','Chose dummy File');
Q = imread(cat(2,pathname,filename));
figure;
imshow(I);
title('Reference Note');
figure;
imshow(Q)
title('Need to be Verified');
load ang;
noisy_i = imnoise(I,'salt & pepper',0.02);
gray_i = rgb2gray(noisy_i);
blur_i = medfilt2(gray_i);
a = blur_i;
curr_img=double(blur_i);
%re_Q=imresize(Q,[300 200]);
re_Q=Q;
Q_dum1=imcrop(Q,rect1);
Q_dum2=imcrop(Q,rect2);
Q_dum3=imcrop(Q,rect3);
Q_dum4=imcrop(Q,rect4);
Q_dum5=imcrop(Q,rect5);
Q_dum6=imcrop(Q,rect6);
figure;

subplot(211)
imshow (Q_dum1);
title('Serial Number Checking');
subplot(212)
imshow(rgb2gray(Q_dum1));
figure;

subplot(211)
imshow (Q_dum2);
title('Asoka Embalam Checking');
subplot(212)
imshow(rgb2gray(Q_dum2));
figure;
subplot(211)
imshow (Q_dum3);
title('Left cross code Checking');
subplot(212)
imshow(rgb2gray(Q_dum3));
figure;
subplot(211)
imshow (Q_dum4);
title('Left Watermark Checking');
subplot(212)
imshow(rgb2gray(Q_dum4));
figure;
subplot(211)
imshow (Q_dum5);
title('Gandhiji Photo Checking');
subplot(212)
imshow(rgb2gray(Q_dum5));
figure;
subplot(211)
imshow (Q_dum6);
title('Grid Line Checking');
subplot(212)
imshow(rgb2gray(Q_dum6));
for i=1:size(curr_img,1)-2
    for j=1:size(curr_img,2)-2
                horizontal_daq=((2*curr_img(i+2,j+1)+curr_img(i+2,j)+curr_img(i+2,j+2))-(2*curr_img(i,j+1)+curr_img(i,j)+curr_img(i,j+2)));
         vertical_daq=((2*curr_img(i+1,j+2)+curr_img(i,j+2)+curr_img(i+2,j+2))-(2*curr_img(i+1,j)+curr_img(i,j)+curr_img(i+2,j)));
        B(i,j)=sqrt(horizontal_daq.^2+vertical_daq.^2);
      
    end
end

Thresh=100;
B=max(B,Thresh);
B(B==round(Thresh))=0;
A=B;
B=uint8(B);
I1=rgb2gray(I);
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I1), hy, 'replicate');
Ix = imfilter(double(I1), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
L = watershed(gradmag);
Lrgb = label2rgb(L);
se = strel('disk', 20);
Io = imopen(I1, se);
Ie = imerode(I1, se);
Iobr = imreconstruct(Ie, I1);
curr_img=double(Iobr);


for i=1:size(curr_img,1)-2
    for j=1:size(curr_img,2)-2
        horizontal_daq=((2*curr_img(i+2,j+1)+curr_img(i+2,j)+curr_img(i+2,j+2))-(2*curr_img(i,j+1)+curr_img(i,j)+curr_img(i,j+2)));
        vertical_daq=((2*curr_img(i+1,j+2)+curr_img(i,j+2)+curr_img(i+2,j+2))-(2*curr_img(i+1,j)+curr_img(i,j)+curr_img(i+2,j)));
      
         B(i,j)=sqrt(horizontal_daq.^2+vertical_daq.^2);
      
    end
end
Thresh=100;
B=max(B,Thresh);
B(B==round(Thresh))=0;
A=B;
curr_img=uint8(B);

seg=curr_img;
figure
imshow(seg);
ref = imresize( I ,[size(Q,1) size(Q,2)]);
i1=crop_grp(ref);
i2=crop_mid(ref);
%i3=crop_lost(ref);
s1=crop_grp(Q);
s2=crop_mid(Q);
c1=corr2(s1,i1);
c2=corr2(s2,i2);
%c3=corr2(s3,i3);
mean_c=(c1+c2)/2;
y=mean_c;
if(mean_c>0)
    p_s=mean_c*100;
else
    p_s=100 - (-mean_c/(1-mean_c)*100);
end
fprintf('Percentage similarity according to correlation is %2.3f percent' , p_s);
if p_s>99
    msgbox('It seems Original');
    figure;
    imshow(Q);
    title('Original note detected');
else
    msgbox('Fake Currency detected');
    figure;
    imshow(Q);
    title('Fake note detected');
end