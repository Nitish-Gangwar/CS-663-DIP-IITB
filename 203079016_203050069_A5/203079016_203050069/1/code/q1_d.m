clc;
clear;
im1=imread('../data/barbara256.png');

im2=imread('../data/stream.png');
%imshow(im2);
im2_patch= im1(1:256,1:256);

%imshow(im2_patch);

sigma_noise=20;
im2_noise1 = double(im2_patch) + double(randn(size(im2_patch))*sigma_noise);
im2_noise=im2_noise1;


im2_noise(im2_noise1>255) = 255;

imagesize = size(im2_noise);
patchsize=7;
neighbourhood=31;

%N=(imagesize(1)-patchsize+1)*(imagesize(2)-patchsize+1);
N=200;
%X_ref_orig=zeros(49,N);

%X_ref_noisy=zeros(49,N);

total_patches = (imagesize(1)-neighbourhood+1) * (imagesize(2)-neighbourhood+1);

times=49;

noised_image=zeros(times,total_patches);
denoised_image=zeros(times,total_patches);
count=1;

reconstructed_image=zeros(256,256);
count_matrix=zeros(256,256);

alpha_denoised=zeros(times,N);
for i=1:(imagesize(1)-neighbourhood+1)
    for j=1:(imagesize(2)-neighbourhood+1)
        x_start=i+((neighbourhood-patchsize)/2)-1;
        y_start=j+((neighbourhood-patchsize)/2)-1;
        
        centermost_patch = im2_noise(x_start:(x_start+patchsize-1),y_start:(y_start+patchsize-1));
        wholewindow = im2_noise(i:(i+neighbourhood-1),j:(j+neighbourhood-1));
        
        noised_image(:,count)=reshape(centermost_patch,1,[])';
        
        x_ref_orig=zeros(49,N);

        %x_ref_noisy=zeros(49,N);
        
        %%%this is qi set i.e. 49*200 on 200 most nearest neighbour
        qi=myPCADenoising2(centermost_patch,wholewindow);
        
        fprintf("At i=%d , j=%d\n",i,j);
        
        [U_noisy,Diag_eigenvalues_noisy,V_noisy]=svd(qi*qi');
        
        
        %%% being computed using only from neighbourhood patches i.e. qi
        alpha_noisy= U_noisy'*qi;
        alpha_one  = U_noisy'*noised_image(:,count);
        times=49;
        
        alpha_j_2 = zeros(times,1);
        for k=1:times
            alpha_j_2(k,1) = max(0,((1/N)*sum(alpha_noisy(k,:).^2))-sigma_noise^2);
        end
        
        for n=1:times
            alpha_denoised(n,count)=(alpha_one(n,1)/( 1+( (sigma_noise^2)/(alpha_j_2(n,1)^2) ) ));
        end
        
        denoised_data = U_noisy*alpha_denoised(:,count);
        
        reconstructed_image(x_start:(x_start+patchsize-1),y_start:(y_start+patchsize-1))=reconstructed_image(x_start:(x_start+patchsize-1),y_start:(y_start+patchsize-1))+reshape(denoised_data,[7,7]);
        count_matrix(x_start:(x_start+patchsize-1),y_start:(y_start+patchsize-1))=count_matrix(x_start:(x_start+patchsize-1),y_start:(y_start+patchsize-1))+ones(7,7);
        
        count=count+1;
    end
end

reconstructed_image1=reconstructed_image./count_matrix;
side = (neighbourhood-patchsize)/2;
reconstructed_image = reconstructed_image1(side:(imagesize(1)-side-1),side:(imagesize(2)-side-1));

%figure,imshow(uint8(reconstructed_image));

%recons  = reconstructed_image(side:(imagesize(1)-side),side:(imagesize(2)-side));
%original= im2_noise(side:(imagesize(1)-side),side:(imagesize(2)-side));

original = im2_patch(side:(imagesize(1)-side-1),side:(imagesize(2)-side-1));

rmse = sqrt(mean((double(original(:)) - double(reconstructed_image(:))).^2));

fprintf('RMSE = %f\n',rmse);


figure,
subplot(1,3,1)
imagesc(original),colormap('gray'),axis off;
title(['Original Image']);

subplot(1,3,2)
imagesc(uint8(im2_noise(side:(imagesize(1)-side-1),side:(imagesize(2)-side-1)))),colormap('gray'),axis off;
title(['Noise added Image']);

subplot(1,3,3)
imagesc(uint8(reconstructed_image)),colormap('gray'),axis off;
caption = sprintf('Reconstructed RMSE: %f',rmse);
title(caption);



function x_ref=myPCADenoising2(centermost_patch,wholewindow)
    l2_norm=zeros((31-7+1)*(31-7+1),1);
    count=1;
    patchsize=7;
    x_ref1=zeros(49,size(l2_norm,1));
    x_ref=zeros(49,200);
    for i=1:(31-patchsize+1) 
        for j=1:(31-patchsize+1)
            variable=wholewindow(i:(i+6),j:(j+6));
            orignal=centermost_patch(1:7,1:7);
            x_ref1(:,count)=reshape(variable,1,[])';
            size(orignal);
            size(variable);
            l2_norm(count,1) = sum(sum((orignal(:)-variable(:)).^2));
            count=count+1;
        end
    end
    [B,I] = sort(l2_norm);
    for i=1:200
        x_ref(:,i)=x_ref1(:,I(i));
    end
end




