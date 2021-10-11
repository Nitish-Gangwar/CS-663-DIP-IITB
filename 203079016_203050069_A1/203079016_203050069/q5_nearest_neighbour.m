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
x1=[40.0000  130.0000  264.0000  391.0000   32.0000  179.0000  236.0000  317.0000  368.0000  204.0000  483.0000  549.0000]
y1=[165.0000   39.0000   81.0000   63.0000  312.0000  218.0000  218.0000  219.0000  217.0000  256.0000  301.0000  301.0000]

x2=[83.0000  169.0000  302.0000  432.0000   70.0000  213.0000  271.0000  355.0000  407.0000  237.0000  536.0000  611.0000]
y2=[187.0000   63.0000   99.0000   74.0000  332.0000  238.0000  236.0000  236.0000  235.0000  278.0000  322.0000  319.0000]
%}
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
        new_v=(affinet)*current_v;
        if new_v(1)<=nrow & new_v(1)>0 & new_v(2)>0 & new_v(2)<=ncol
            
            neighbor(1)=floor(new_v(1));
            neighbor(2)=ceil(new_v(1));
            neighbor(3)=floor(new_v(2));
            neighbor(4)=ceil(new_v(2));

            X1=neighbor(1);
            X2=neighbor(2);
            Y1=neighbor(3);
            Y2=neighbor(4);


            q11=I2(X1,Y1);
            q12=I2(X1,Y2);
            q21=I2(X2,Y1);
            q22=I2(X2,Y2);

            x=i;
            y=j;

            d1= sqrt((x-X1)^2 + (y-Y1)^2);

            d2= sqrt((x-X2)^2+(y-Y1)^2);

            d3= sqrt((x-X1)^2 + (y-Y2)^2);

            d4= sqrt((x-X2)^2 + (y-Y2)^2);

            distances=[d1 d2 d3 d4];
            for m= 1:4
                if distances(m)==min(distances)
                    index_match=m;
                    break
                end
            end
            if index_match==1
                newI(i,j)=I2(X1,Y1);
            elseif index_match==2
                newI(i,j)=I2(X2,Y1);
            elseif index_match==3
                newI(i,j)=I2(X1,Y2);
            elseif index_match==4
                newI(i,j)=I2(X2,Y2);
            end
            
        end
        
    end
end

figure,
imshow((newI)/255);
