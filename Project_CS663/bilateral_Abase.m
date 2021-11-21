%im_noflash = imread("carpet_01_noflash.jpg");
%im_flash = imread("carpet_00_flash.jpg");

%k = bilateral_Abase(im_noflash,3 ,100);

function Abase = bilateral_Abase(im_nf,sigma_d,sigma_r)
[H,W,C] = size(im_nf);
im_nf_norm = rescale(im_nf);
out = zeros(size(im_nf_norm)); %Abase
for k = 1:C
    fprintf("%d,", k);
    for i=1:H
        %fprintf("%d,%d \n", k,i);
        for j=1:W
            minx = max([1,floor(j-3*sigma_d)]);
            maxx = min([W,floor(j+3*sigma_d)]);
            miny = max([1,floor(i-3*sigma_d)]);
            maxy = min([H,floor(i+3*sigma_d)]);
            [X,Y] = meshgrid(minx:maxx,miny:maxy);
            w_s = exp(-((X-j).^2 +(Y-i).^2)/(2*sigma_d*sigma_d));
            w_r = exp(-((im_nf_norm(i,j,k)-im_nf_norm(miny:maxy,minx:maxx,k)).^2)/(2*sigma_r*sigma_r));
            out(i,j,k) = sum(sum(w_s.*w_r.*im_nf_norm(miny:maxy,minx:maxx,k)))/sum(sum(w_s.*w_r));
        end
    end
end
%subplot(1,2,1);imshow(im_nf_norm);title('normalised image');
%subplot(1,2,2);imshow(rescale(out)); title('A base bilateral filter nf output');
Abase = out;
end