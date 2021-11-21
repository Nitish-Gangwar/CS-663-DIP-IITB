function reconstructed_image=myPCADenoising1(im2_patch)

sigma_noise=20;

im2_noise = double(im2_patch) + double(randn(size(im2_patch))*sigma_noise);

imagesize = size(im2_noise);

patchsize=7;

count=1;

N=(imagesize(1)-patchsize+1)*(imagesize(2)-patchsize+1);

X_ref_orig=zeros(49,N);

X_ref_noisy=zeros(49,N);

for i=1:(imagesize(1)-patchsize+1)
    for j=1:(imagesize(2)-patchsize+1)
        
        imagedata_noisy = im2_noise(i:(i+patchsize-1),j:(j+patchsize-1));
        imagedata_orig =  im2_patch(i:(i+patchsize-1),j:(j+patchsize-1));
        
        X_ref_noisy(:,count) = reshape(imagedata_noisy,1,[])';
        
        X_ref_orig(:,count)= reshape(imagedata_orig,1,[])';
        
        count=count+1;
    end
end

%%% computation of eigen vectors
[U_noisy,Diag_eigenvalues_noisy,V_noisy]=svd(X_ref_noisy*X_ref_noisy');

[U_orig,Diag_eigenvalues_orig,V_orig]=svd(X_ref_orig*X_ref_orig');

%%% computation of eigen coefficients
alpha_noisy= U_noisy'*X_ref_noisy;

alpha_orig =  U_orig'*X_ref_orig;

times=patchsize*patchsize;
alpha_j_2 = zeros(times,1);

for i=1:times
    alpha_j_2(i,1) = max(0,((1/N)*sum(alpha_orig(i,:).^2))-sigma_noise^2);
end

alpha_denoised=zeros(times,N);
%%% weiner filter coefficient update
for i=1:N
    for j=1:times
        alpha_denoised(j,i)=(alpha_noisy(j,i)/( 1+( (sigma_noise^2)/(alpha_j_2(j,1)^2) ) ));
    end
end


denoised_data = U_noisy*alpha_denoised;
count=1;
reconstructed_image=zeros(256,256);
count_matrix=zeros(256,256);
for i=1:(imagesize(1)-patchsize+1)
    for j=1:(imagesize(2)-patchsize+1)
        reconstructed_image(i:i+patchsize-1,j:j+patchsize-1)=reconstructed_image(i:i+patchsize-1,j:j+patchsize-1)+reshape(denoised_data(:,count),[7,7]);
        count_matrix(i:i+patchsize-1,j:j+patchsize-1)=count_matrix(i:i+patchsize-1,j:j+patchsize-1)+ones(7,7);
        count=count+1;
    end
end

reconstructed_image=reconstructed_image./count_matrix;
%figure,imshow(uint8(reconstructed_image));
%{
figure,imshow(uint8(reconstructed_image));
caption = sprintf('Reconstructed Image');
title(caption);
impixelinfo;
%}
rmse = sqrt(mean((double(im2_patch(:)) - reconstructed_image(:)).^2));
fprintf('RMSE = %f\n',rmse);


figure,
subplot(1,3,1)
imagesc(im2_patch),colormap('gray'),axis off;
title(['Original Image']);

subplot(1,3,2)
imagesc(im2_noise),colormap('gray'),axis off;
title(['Noise added Image']);

subplot(1,3,3)
imagesc(uint8(reconstructed_image)),colormap('gray'),axis off;
caption = sprintf('Reconstructed RMSE: %f',rmse);
title(caption);
end
