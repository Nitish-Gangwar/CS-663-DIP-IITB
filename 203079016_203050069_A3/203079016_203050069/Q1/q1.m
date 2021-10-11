tic;
img1=imread('barbara256.png');
%im1=double(img1(50:150,50:150));
im1=double(img1);
%imshow(uint8(im1));

std=5;
variance=std^2;

im1 = im1 + normrnd(0,std,size(im1));
noisy_image=im1/255.0;
%im1=rescale(im1);

im_size = size(noisy_image);

output = zeros(im_size);


%figure,imshow(uint8(noisy_image.*255.0));


% since image is gray scale so datavector will be 3 dimensional
data_vector = zeros(3,im_size(1)*im_size(2));



for i=1:im_size(1)
    for j=1:im_size(2)
        data_vector(:,im_size(2)*(i-1) + j)=[i;j;noisy_image(i,j)];
    end
end

data = double(data_vector');

datasize= size(data);

h_s=3;
h_r=15;

for i=1:datasize(1)
    old_x=zeros(1,3)*1.0;
    fprintf("%d\n",i);
    epsilon=0.1;
    new_x=1.0*(ones(1,3));
    term=double(0);
    prev_data=data(i,:);
    count=0;
    while abs((old_x(3)-new_x(3)))>epsilon
        %fprintf('%f\n',abs(sum(old_x-new_x)));
        total=0;
        numerator = zeros(1,3);
        denominator=0;
        for j=1:datasize(1)
                % for spatial
                term1 = exp(-1.0* ( (data(i,1)-data(j,1)).^2+(data(i,2)-data(j,2)).^2)/(2*((h_s*h_s))));
                % for intensity
                term2 = exp(-1.0*(((data(i,3)-data(j,3))^2)/(2*(h_r^2))));
                
                term = term1 * term2;
                numerator = numerator + (data(j,:) .* term);
                denominator = denominator + term;
        end
        newval = zeros(1,3);
        old_x;
        newval = (numerator)./denominator;
        data(i,:) = numerator./denominator;
        old_x= new_x;
        new_x= data(i,:);
        count=count+1;
        %disp('value converged');
    end
   
    %fprintf("steps to converge %d\n",count);
    %fprintf('old = (%d %d %d)\t new = (%d %d %d)\n',prev_data(1),prev_data(2),prev_data(3),new_x(1),new_x(2),new_x(3));
    %disp(prev_data-data);
    
end
new_im = reshape(data(:,3),[im_size(1),im_size(2)]);
new_im=new_im.*255.0;

noisy_image = uint8(noisy_image.*255.0);
updated_image = uint8( imrotate(rot90(new_im,3),90)');


figure,imshow(uint8(noisy_image));
%figure,imshow(uint8(new_im));

figure,imshow(uint8(updated_image));



diff=sum(sum(updated_image-uint8(noisy_image)));

toc;





