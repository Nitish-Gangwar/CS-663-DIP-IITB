clc;
clear;
im=imread('LC1.png');
%im=imread('LC2.jpg');

[row,col]=size(im);

% change here to check output for multiple size patch size
patchsize=71;



histo_eq_im=zeros(row,col);

for i=1:patchsize:row
    for j=1:patchsize:col
        if ((i+patchsize)>row) ||((j+patchsize)>col)
            continue
        end
        %fprintf("\n %d %d %d %d\n",i,i+patchsize,j,j+patchsize);
        histo_s=patchwise_equalization(im,i,j,i+patchsize-1,j+patchsize-1);
        
        for k=0:255
            temp_mat=zeros(patchsize);
            indices_direct=find(im==k);
            histo_eq_im(indices_direct)=histo_s(k+1);
        end
    end
end

J = histeq(im);

figure,subplot(1,3,1),imshow(im),title("original image");
subplot(1,3,2),imshow(J),title("globally Histogram equalized image");
subplot(1,3,3),imshow(uint8(histo_eq_im)),title("Histo equalized image with 71*71 patch");


function histo_s = patchwise_equalization(im,x1,y1,x2,y2)
    
    %make histogram
    histo=zeros(1,256);

    %run loop to find all bin counts
    for i=x1:x2
        for j=y1:y2
            value=im(i,j);
            histo(1,value+1)=histo(1,value+1)+1;
        end
    end
    
    % finding probability ps
    hgt=x2-x1;
    wdt=y2-y1;
    p_histo= histo/(hgt*wdt);

    % finding cumulative distribution
    p_histo_sum=cumsum(p_histo);

    % multiplying with L-1 for finding out the pk
    histo_s= p_histo_sum*255;

    %rounding off to nearmost value
    histo_s = uint8(histo_s);

end

