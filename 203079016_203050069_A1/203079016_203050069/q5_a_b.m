I1=(imread("goi1.jpg"));
I2=(imread("goi2_downsampled.jpg"));

g1=double(I1);
g2=double(I2);
%figure,imshow(g1/255);
%figure,imshow(g2/255);


for i=1:12, figure(1); imshow(g1/255); [x1(i), y1(i)] = ginput(1);
figure(2); imshow(g2/255); [x2(i), y2(i)] = ginput(1);
end


%{
x1=[154   364   155   368   155   379   180   265   180   149   203   431]
y1=[72.0000   86.0000   99.0000  106.0000  154.0000  161.0000  178.0000  179.0000  218.0000  250.0000  256.0000  244.0000]
x2=[193   406   191   410   189   419   215   300   214   180   237   475]
y2=[93.0000   99.0000  120.0000  119.0000  176.0000  177.0000  196.0000 200.0000  238.0000  271.0000  277.0000  263.0000]
%}


fixpoints(1,:)= x1;
fixpoints(2,:)= y1;
fixpoints(3,:)=ones(1,12);

movedpoints(1,:)=x2;
movedpoints(2,:)=y2;
movedpoints(3,:)=ones(1,12);

%p2 P1'(P1 P1')^(-1) = A 

p1=fixpoints;
p2=movedpoints;

tform1 = (p2*p1')*inv(p1*p1');

%disp(movedpoints([1 2]]))
b1=fixpoints([1 2],[1:12])';
b2=movedpoints([1 2],[1:12])';

registered_image=zeros(size(g1));
registered_image=g2;
size_g2=size(g2);

for i= 1:size_g2(1)
    for j= 1:size_g2(2)
        curr=[i;j;1];
        val=tform1*curr;
        registered_image(int16(val(1)),int16(val(2)))=g1(i,j);
    end
end

        
figure,imshow(registered_image/255)

