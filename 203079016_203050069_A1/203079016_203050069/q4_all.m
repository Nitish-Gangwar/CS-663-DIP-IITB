clc;clear;
%4a
im1=imread("T1.jpg");
im2=imread("T2.jpg");
J1=double(im1);
J2=double(im2);
J3=double(imrotate(im2,28.5,"bilinear","crop"));
imshow(imrotate(im2,28.5,"bilinear","crop"));
imshow(J3);
a=ncc(J1,J3);
x_ncc=zeros(91,1);
count=1;

for theta=-45:1:45
    J4=imrotate(J3,theta,"bilinear","crop");
    x=ncc(J1,J4);
    x_ncc(count)=sum(x);
    count=count+1;
end
figure(1);
the=-45:1:45;
plot(the,x_ncc);



%Je
%clc;clear;
je=zeros(91,1);

for theta=-45:1:45
    J1=double(imread("T1.jpg"));
    J4=double(imrotate(imread("T1.jpg"),(28.5+theta),"bilinear","crop"));
    J1(J1 < 0) = 0; J1(J1 > 255)= 255;
    J4(J4 < 0) = 0; J4(J4 > 255)= 255;
    b=jointhist(J1,J4);
    k=log2(b);
    l=(-b.*k); %joint enttropy
    m=sum(l,"all");
    je(46+theta)=m;
end

figure(2);
the=-45:1:45;
je(isnan(je))=0;
plot(the,je);



%qmi

%clc;clear;
J1=double(imread("T1.jpg"));
J3=double((imread("T2.jpg")));
%J4=double(imread("T2.jpg"));
%s=jointminusp1p2_square_qmi(J1,J4)
qmi=zeros(91,1);
count=1;
for theta=-45:1:45
    J4=imrotate(J3,theta+28.5,"bilinear","crop");
    n=jointminusp1p2_square_qmi(J1,J4);
    qmi(count)=n;
    count=count+1;
end
figure(3);
the= -45:1:45;
plot(the,qmi);

figure(4);
opti_rotn=imrotate(J3,-28.3,"bilinear","crop")
opt_hist=jointhist(J1,opti_rotn);
imagesc(opt_hist)
colorbar

function a=jointminusp1p2_square_qmi(o,p)
nbin=10;
x1=o(:); %conversion to vector
x2=p(:);
%bin formation
v1=floor(x1/nbin)+1;
v2=floor(x2/nbin)+1;
quantisation_levels=ceil(255/nbin);
joint=zeros(quantisation_levels);
for m=1:length(x1)
    joint(v1(m),v2(m))=joint(v1(m),v2(m))+1; %pdf formation with the value
end
joint=joint/sum(joint(:)); %Normalisation of the pdf
p1=sum(joint,1);
p2=sum(joint,2);
p1p2=zeros(size(p1));
for i=1:size(p1)
    for j=1:size(p1)
        p1p2(i,j)=p1(i)*p2(j);
    end
end
a=sum(sum((joint-p1p2).^2));
end

function a=jointhist(J1,J3)
nbin=10;
x1=J1(:); %conversion to vector
x2=J3(:);
%bin formation
v1=floor(x1/nbin)+1;
v2=floor(x2/nbin)+1;
quantisation_levels=ceil(255/nbin);
joint=zeros(quantisation_levels);
for m=1:length(x1)
    joint(v1(m),v2(m))=joint(v1(m),v2(m))+1; %pdf formation with the value
end
joint=joint/sum(joint(:)); %Normalisation of the pdf

a=joint;
end

function n=ncc(p,q)
n = dot(p-mean(p),q-mean(q))/norm(p-mean(p))*norm(q-mean(q));
end
