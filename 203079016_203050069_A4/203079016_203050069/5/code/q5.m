clc;
clear;

imagefiles = dir('../../ORL/*/*.pgm');
%no_of_folders = dir('ORL/s*');
nfiles = length(imagefiles);

% will fetch the current working directory
base_directory = pwd;

Trainfoldercount=32;
Trainimagecount=6;
Testimagecount=4;
count=1;
N_train = Trainfoldercount*Trainimagecount;
N_test  = Trainfoldercount*Testimagecount;

% These values denotes the number of components to be used 
testset=[1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];

train_images=zeros(112*92, N_train);
test_images = zeros(112*92 , N_test);

X=zeros(112*92 , N_train);

original_train_label=zeros(N_train,1);

for i=1:Trainfoldercount
    for j=1:Trainimagecount
        imagepath = strcat('../../ORL/s',num2str(i),'/',num2str(j),'.pgm');
        imagedata=imread(imagepath);
        train_images(:,count) = reshape(imagedata,1,[])';
        original_train_label(count,1)=i;
        count=count+1;
    end
end

original_test_label=zeros(N_test,1);
count=1;
for i=1:Trainfoldercount
    for j=7:10
        imagepath = strcat('../../ORL/s',num2str(i),'/',num2str(j),'.pgm');
        imagedata=imread(imagepath);
        test_images(:,count) = reshape(imagedata,1,[])';
        original_test_label(count,1)=i;
        count=count+1;
    end
end

X = train_images;

X_test = zeros(112*92,N_test);

X_test = test_images;

%%% denotes the mean across columns 
X_hat = mean(X,2);

%%% Standarized data
X_data = zeros(112*92 , N_train);

%%% mean deducted train data
X_data = X - X_hat;

%%% mean deducted test data
X_test_hat = X_test - X_hat;

%%% let's compute L matrix i.e. L= X^T*X

L = zeros(N_train,N_train);
L= X_data' * X_data;

[u,s,v] = svd(X_data,'econ');

U_normalized = normc(u);
%%% these are the eigen vectors for all the eigenvalues from here 
%%% we can select the top k values as asked


recognition_rate=zeros(size(testset,2),1);
for i=1:length(testset)
    train_coeff= U_normalized(:,1:testset(i))' * X_data;
    test_coeff = U_normalized(:,1:testset(i))'* X_test_hat;
    matchcount=0;
    for j=1:size(X_test,2)
        least_square_diff = bsxfun(@minus, train_coeff, test_coeff(:,j)).^2;
        error_sum = sum(least_square_diff,1);
        [value,index] = min(error_sum);
        if(original_train_label(index,1) == original_test_label(j))
            matchcount=matchcount+1;
        end
        
    %fprintf('Match count at %d is %d\n',testset(i),matchcount);   
    end
    recognition_rate(i)=100*(matchcount/size(X_test,2));
end
fprintf('Through SVD maximum value = %d \n',max(recognition_rate));
%{
plot(testset,recognition_rate), 
xlabel('k'), ylabel('Acc')
title('Recognition rates obtained over ORL dataset using SVD')
%}
%source used:https://www.youtube.com/watch?v=dN4hIUhjUt0

% Facial recognition using another method i.e. usig eig 

L = X_data'*X_data;

[eigenvectors,Diagonal]=eig(L);

eigenvalues=diag(Diagonal);

[new_mat,sorted_indices]=sort(eigenvalues,'descend');

V = normc(X_data*eigenvectors);

for i=1:length(testset)
    top_V=V(:,sorted_indices(1:testset(i)));
    train_coeff= top_V' * X_data;
    test_coeff = top_V'* X_test_hat;
    matchcount=0;
    for j=1:size(X_test,2)
        least_square_diff = bsxfun(@minus, train_coeff, test_coeff(:,j)).^2;
        error_sum = sum(least_square_diff,1);
        [value,index] = min(error_sum);
        
        if(original_train_label(index,1) == original_test_label(j))
            matchcount=matchcount+1;
        end
        
    %fprintf('Match count at %d is %d\n',testset(i),matchcount);   
    end
    recognition_rate(i)=100*(matchcount/size(X_test,2));
end

fprintf('Through EIG maximum value = %d\n',max(recognition_rate));


%%% Reading a test image just to show results
imagepath = strcat('../../ORL/s37/1.pgm');
image = imread(imagepath);

image_reshaped = double(reshape(image,1,[])');

w=112;
h=92;

figure,
subplot(3,4,1)
imagesc(reshape(image,112,92)),colormap('gray'),axis off;
title(['Original Image']);


count=1;
image_mean_deducted = double(image_reshaped) - double(X_hat);
components=[2, 10, 20, 50, 75, 100, 125, 150, 175];
for i=1:length(components)
    count=count+1;
    subplot(3,4,count);
    U_selected=V(:,sorted_indices(1:components(i)));
    %U_selected = U_normalized(:,1:components(i));
    %U_selected = u(:,1:components(i));
    newface = double(X_hat)+double(U_selected*U_selected'*image_mean_deducted);
    imagesc(reshape(newface,112,92)),colormap('gray'),axis off;
    title(['i= ',num2str(components(i),'%d')]);
end

%%% Source used = https://www.youtube.com/watch?v=dN4hIUhjUt0



%%% next 25 sorted eigenvectors
figure,
subplot(5,5,1)

for i=1:25
    %count=count+1;
    subplot(5,5,i);
    U_selected=V(:,sorted_indices(i));
    %U_selected = U_normalized(:,1:components(i))
    %newface = double(X_hat)+double(U_selected*U_selected'*image_mean_deducted);
    imagesc(reshape(U_selected,112,92)),colormap('gray'),axis off;
    %title(['i= ',num2str((i),'%d')]);
end


