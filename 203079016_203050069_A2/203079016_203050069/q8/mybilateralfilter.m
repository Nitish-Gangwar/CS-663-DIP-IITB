clc;clear;

img1=imread('barbara256.png');
img2=imread('kodak24.png');

im1=double(img1);
im2=double(img2);


%%%% please change the value of standard deviation here
std=25;
variance=std^2;

im1 = im1 + normrnd(0,std,size(im1));
im2 = im2 + normrnd(0,std,size(im2));

imwrite(uint8(im1),'barbara_noise_10.jpg');
imwrite(uint8(im2),'kodak_noise_10.jpg');

%%%% please change the value of sigma_s and sigma_r here
sigma_s=0.1;
sigma_r=0.1;


[outputimage1,sp1]= mybilateralfiltering(im1,sigma_s,sigma_r);
figure,subplot(1,2,1),imshow(uint8(im1)),title("original image");
subplot(1,2,2),imshow(uint8(outputimage1)),title("bilateral filtering image");
%imwrite(uint8(outputimage1),'barbara_0_1_0_1_std_10.jpg')




[outputimage2,sp21]= mybilateralfiltering(im2,sigma_s,sigma_r);

figure,subplot(1,2,1),imshow(uint8(im2)),title("original image");
subplot(1,2,2),imshow(uint8(outputimage2)),title("bilateral filtering image");
%imwrite(uint8(outputimage2),'kodak_0_1_0_1_std_10.jpg')




function [outputimage, spatial] = mybilateralfiltering(img,sigma_s,sigma_r)

windowsize=round(3*sigma_s+1)



pad_size = [windowsize windowsize];

padded_img= padarray(img,pad_size,0,'both');

[padrowend,padcolend]=size(padded_img)

spatial=double(zeros(2*windowsize+1,2*windowsize+1));

outputimage=zeros(size(img));

for x = -windowsize:windowsize
    for y=-windowsize:windowsize
        spatial(x+windowsize+1,y+windowsize+1)= (1/2*pi*sigma_s^2)*exp(-1*((x)^2+(y)^2)./(2*sigma_s^2));
    end
end
for rowi = windowsize+1:padrowend-windowsize  
     for colj = windowsize+1:padcolend-windowsize      
         window=padded_img((rowi-windowsize):(rowi+windowsize),(colj-windowsize):(colj+windowsize));      
         intensity = (1/2*pi*sigma_r^2)*exp(-1*((window-padded_img(rowi,colj)).^2)./(2*(sigma_r)^2));    
         outputimage(rowi-windowsize,colj-windowsize)=(sum(window.*spatial.*intensity))/(sum(spatial.*intensity));
     end
end
end
