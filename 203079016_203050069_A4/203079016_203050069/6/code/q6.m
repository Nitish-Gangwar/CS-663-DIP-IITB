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
test_images_known = zeros(112*92 , N_test);

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

%%% This part is for reading the remaining 4 images from the folder 1 to 32
original_test_label=zeros(N_test,1);
count=1;
for i=1:Trainfoldercount
    for j=7:10
        imagepath = strcat('../../ORL/s',num2str(i),'/',num2str(j),'.pgm');
        imagedata=imread(imagepath);
        test_images_known(:,count) = reshape(imagedata,1,[])';
        original_test_label(count,1)=i;
        count=count+1;
    end
end


%%% This part is for reading the images from the folder 33 to 40 
test_images_unknown=zeros(112*92,80);
count=1;
for i= 33:40
    for j=1:10
        imagepath = strcat('../../ORL/s',num2str(i),'/',num2str(j),'.pgm');
        imagedata=imread(imagepath);
        test_images_unknown(:,count) = reshape(imagedata,1,[])';
        %original_test_label(count,1)=i;
        count=count+1;
    end
end


X = train_images;

X_test_known = zeros(112*92,N_test);

X_test_known = test_images_known;
X_test_unknown = test_images_unknown;

%%% denotes the mean across columns 
X_hat = mean(X,2);

%%% Standarized data
X_data = zeros(112*92 , N_train);

%%% mean deducted train data
X_data = X - X_hat;

%%% mean deducted test data
X_test_known_hat = X_test_known - X_hat;
X_test_unknown_hat = X_test_unknown - X_hat;
%%% let's compute L matrix i.e. L= X^T*X

L = zeros(N_train,N_train);
L= X_data' * X_data;

[u,s,v] = svd(X_data,'econ');

U_normalized = normc(u);
%%% these are the eigen vectors for all the eigenvalues from here 
%%% we can select the top k values as asked


recognition_rate=zeros(size(testset,2),1);
%for i=1:length(testset)
    
train_coeff= U_normalized(:,1:75)' * X_data;
test_coeff_known = U_normalized(:,1:75)'* X_test_known_hat;
matchcount=0;

man_threshold=55;

false_positive=0;
false_negative=0;

for j=1:size(X_test_known,2)
    least_square_diff = bsxfun(@minus, train_coeff, test_coeff_known(:,j)).^2;
    error_sum = sum(least_square_diff,1);
    [value,index] = min(error_sum);
    if((value/100000) > man_threshold)
        false_negative=false_negative+1;
    end
end
fprintf('false negative = %d\n',false_negative);

test_coeff_unknown = U_normalized(:,1:75)'* X_test_unknown_hat;

for j=1:80
    least_square_diff = bsxfun(@minus, train_coeff, test_coeff_unknown(:,j)).^2;
    error_sum = sum(least_square_diff,1);
    [value,index] = min(error_sum);
    if((value/100000) < man_threshold)
        false_positive=false_positive+1;
    end
end
fprintf('false positive = %d\n',false_positive);