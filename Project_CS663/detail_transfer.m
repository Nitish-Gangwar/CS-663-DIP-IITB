im_noflash = imread("carpet_01_noflash.jpg");
im_flash = imread("carpet_00_flash.jpg");
k = fdetail_transfer(im_flash,3 ,100);

function fdet = fdetail_transfer(flash ,sigma_d,sigma_r)
eps = 0.02 ;
fbase = bilateral_Abase(flash , sigma_d,sigma_r);
fbase = im2double(fbase);flash=im2double(flash);
out = (flash + eps)./(fbase+eps);
out = uint8(out);
figure(1);imshow(rescale(out)) ;title("details to be transfered ");
fdet = rescale(out) ;
end
