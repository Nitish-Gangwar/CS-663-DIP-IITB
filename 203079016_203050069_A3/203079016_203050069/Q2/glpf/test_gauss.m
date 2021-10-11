clc;clear;
im=imread('barbara256.png');
a=im2double(im);
[m,n] = size(a);
im1 = zeros(2*m,2*n); %zeros matrix
[p,q] = size(im1);

for i=  1:m
    for j= 1:n
        im1(i,j)=a(i,j);
    end
end

%figure(1);
%imshow(im1);

IM =fftshift(fft2(im1));
absIM = log(abs(IM)+1);
%figure(2);
%imshow(absIM);
%colormap (jet); colorbar;

f40= lpfgauss(40,p,q);
figure(3)
imshow(log(abs(f40))+1);
colormap (jet); colorbar;

f40response = IM.*f40;
figure(4)
imshow(log(abs(f40response)+1));
colormap (jet); colorbar;
im40 = ifft2(ifftshift(f40response));
figure(5);
x = im40(1:256,1:256);
imshow(x);

f80= lpfgauss(80,p,q);
figure(6)
imshow(log(abs(f80))+1);
colormap (jet); colorbar;

f80response = IM.*f80;
figure(7)
imshow(log(abs(f80response)+1));
colormap (jet); colorbar;
im80 = ifft2(ifftshift(f80response));
figure(8);
xx = im80(1:256,1:256);
imshow(xx);

function a=lpfgauss(sigma,w1,w2)
X=0:w1-1;
Y=0:w2-1;
[X, Y]=meshgrid(X,Y);
u=0.5*w1;
v=0.5*w2;
D=exp(-2.*((X-u).^2+(Y-v).^2)./(2*sigma).^2);
a=D;
end