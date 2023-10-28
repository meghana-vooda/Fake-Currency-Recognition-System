function GS1=crop_grp(img)

%%%%%%%%%%%%
I=rgb2gray(img);
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
L = watershed(gradmag);
Lrgb = label2rgb(L);
se = strel('disk', 20);
Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
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
C=B;
B=uint8(B);
seg=C;
%%%%%%%%%%%%%%%%%%
I2 = imcrop(C,[10 80 40 130])
GS1=I2
figure
imshow(GS1)
title('Test Section1')
end