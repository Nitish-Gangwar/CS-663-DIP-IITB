I1=double(imread("goi1.jpg"));
I2=double(imread("goi2_downsampled.jpg"));
g1=double(I1);
g2=double(I2);
figure,imshow(g1/255);
figure,imshow(g2/255);

x1=[154   364   155   368   155   379   180   265   180   149   203   431];
y1=[72.0000   86.0000   99.0000  106.0000  154.0000  161.0000  178.0000  179.0000  218.0000  250.0000  256.0000  244.0000];
x2=[193   406   191   410   189   419   215   300   214   180   237   475];
y2=[93.0000   99.0000  120.0000  119.0000  176.0000  177.0000  196.0000 200.0000  238.0000  271.0000  277.0000  263.0000];

%{
for i=1:12, figure(1); imshow(g1/255); [x1(i), y1(i)] = ginput(1);
figure(2); imshow(g2/255); [x2(i), y2(i)] = ginput(1);
end
%}


fixpoints(1,:)= x1;
fixpoints(2,:)= y1;
fixpoints(3,:)=ones(1,12);

movedpoints(1,:)=x2;
movedpoints(2,:)=y2;
movedpoints(3,:)=ones(1,12);


p1=fixpoints
p2=movedpoints

tform1 = (p2*p1')*inv(p1*p1');

affinet=tform1;

tot_size=size(I1);

newI=zeros(tot_size(1),tot_size(2));

newI=I1;

nrow=size(I1,1)
ncol=size(I1,2)

for i=1:1:nrow
    for j=1:1:ncol
        current_v=[i;j;1];
        new_v =(affinet)*current_v;
        if new_v(1)<=nrow & new_v(1)>0 & new_v(2)>0 & new_v(2)<=ncol
          
            x=floor(new_v(1));
            y=floor(new_v(2));
            dx=new_v(1)-x;
            dy=new_v(2)-y;
            newintensity = I2(x,y)*dx*dy + (1-dx)*dy*I2(1+x,y) + (1-dy)*(dx)*I2(x,1+y) + (1-dx)*(1-dy)*I2(1+x,1+y);
           
            newI(i,j) = newintensity;
           
        end
    end
end
figure,
imshow(newI/255)
