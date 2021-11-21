clc;
clear;

imagefiles = dir('../../CroppedYale/*/*.pgm');
%no_of_folders = dir('CroppedYale/yaleB*');
nfiles = length(imagefiles);

% will fetch the current working directory
base_directory = pwd;

Trainfoldercount=39;
%%%change Trainfoldercount to 39
Trainimagecount=40;
Testimagecount=24;

N_train = (Trainfoldercount-1)*Trainimagecount;
%N_test  = (Trainfoldercount-1)*Testimagecount;

% These values denotes the number of components to be used 
testset=[1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];

train_images=zeros(192*168, N_train);

X=zeros(192*168 , N_train);

original_train_label=zeros(N_train,1);

count=1;
test_images_count=0;
for i=1:Trainfoldercount
    if(i==14)
        continue;
    end
    
    if(i < 10)
        dir_path=strcat('../../CroppedYale/yaleB0',num2str(i),'/*.pgm');
        image_file_names = dir(dir_path);
    end
    
    if(i >= 10)
        dir_path = strcat('../../CroppedYale/yaleB*',num2str(i),'/*.pgm');
        image_file_names = dir(dir_path);
    end
    
    for j=1:Trainimagecount
        
        imagepath = strcat(image_file_names(j).folder,'/',image_file_names(j).name);
        imagedata=imread(imagepath);
        train_images(:,count) = reshape(imagedata,1,[])';
        original_train_label(count,1)=i;
        count=count+1;
    end
    temp = (size(image_file_names,1)-40)
    test_images_count = test_images_count + temp;
end

N_test = test_images_count;

original_test_label=zeros(N_test,1);
count=1;
no_of_images = 0;

test_images = zeros(192*168 , test_images_count);

for i=1:Trainfoldercount
    
    if(i==14)
        continue;
    end
    
    if(i < 10)
        dir_path=strcat('../../CroppedYale/yaleB0',num2str(i),'/*.pgm');
        image_file_names = dir(dir_path);
    end
    
    if(i >= 10)
        dir_path = strcat('../../CroppedYale/yaleB*',num2str(i),'/*.pgm');
        image_file_names = dir(dir_path);
    end
    
    for j=41:size(image_file_names,1)
        image_path = strcat(image_file_names(j).folder,'/',image_file_names(j).name);
        imagedata=imread(imagepath);
        test_images(:,count) = reshape(imagedata,1,[])';
        original_test_label(count,1)=i;
        count=count+1;
    end
end


X = train_images;

X_test = zeros(192*168,N_test);

X_test = test_images;

%%% denotes the mean across columns 
X_hat = mean(X,2);

%%% Standarized data
X_data = zeros(192*168 , N_train);

%%% mean deducted train data
X_data = X - X_hat;

%%% mean deducted test data
X_test_hat = X_test - X_hat;

%%% let's compute L matrix i.e. L= X^T*X

L = zeros(N_train,N_train);
%L= X_data' * X_data;

[u,s,v] = svd(X_data,'econ');

%U_normalized = normc(u);
%%% these are the eigen vectors for all the eigenvalues from here 
%%% we can select the top k values as asked


recognition_rate=zeros(size(testset,2),1);
for i=1:length(testset)
    U_normalized = normc(u(:,1:testset(i)));
    train_coeff= U_normalized' * X_data;
    test_coeff = U_normalized'* X_test;
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
figure,
plot(testset,recognition_rate), 
xlabel('k'), ylabel('Acc')
title('Recognition rates obtained over YaleB dataset using SVD')

%source used:https://www.youtube.com/watch?v=dN4hIUhjUt0

% Facial recognition using another method i.e. usig eig 

L = X_data'*X_data;

[eigenvectors,Diagonal]=eig(L);

eigenvalues=diag(Diagonal);

[new_mat,sorted_indices]=sort(eigenvalues,'descend');

V = normc(X_data*eigenvectors);
recognition_rate=zeros(size(testset,2),1);
for i=1:length(testset)
    top_V=V(:,sorted_indices(1:testset(i)));
    train_coeff= top_V' * X_data;
    test_coeff = top_V'* X_test;
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

figure,plot(testset,recognition_rate), 
xlabel('k'), ylabel('Acc')
title('Recognition rates obtained over YaleB dataset using eig')

recognition_rate=zeros(size(testset,2),1);
for i=1:length(testset)
    %top_V2=V(:,sorted_indices(4:(testset(i)+3)));
    top_V2 = normc(u(:,4:testset(i)+3));
    train_coeff= top_V2' * X_data;
    test_coeff = top_V2'* X_test;
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

figure,plot(testset,recognition_rate), 
xlabel('k'), ylabel('Acc')
title('Recognition rates obtained over YaleB dataset avoiding first 3 eigenvectors using SVD')




