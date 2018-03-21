% jpeg decoder
clear,clc;
load jpegcodes.mat
load JpegCoeff.mat
% DC decode
DC_coeff = DC_decoding(DC_stream, DCTAB, h, w);
% AC decode
AC_coeff = AC_decoding(AC_stream, ACTAB, h, w);
% coefficient after quantization 
coeff_q = AC_coeff;
k = 0;
for i = 1:8:h
    for j = 1:8:w
        k = k + 1;
        coeff_q(i,j) = DC_coeff(k);
    end
end
result_block_a = cell(h/8,w/8);
result_block_b = cell(h/8,w/8);
image_decode = zeros(h,w);
for x = 1:h/8
    for y = 1:w/8
        % partitioning
        result_block_a{x,y}(1:8,1:8) = coeff_q(1+(x-1)*8:x*8,1+(y-1)*8:y*8);
        % inverse quantization
        result_block_b{x,y}(1:8,1:8) = result_block_a{x,y}(1:8,1:8).*QTAB;
        % IDCT and splice
        image_decode((x-1)*8+1:x*8,(y-1)*8+1:y*8) = idct2(result_block_b{x,y}(1:8,1:8))+128;
    end
end
save('3_1_image_decode.mat','image_decode');
image_show = uint8(image_decode);
imshow(image_show)
imwrite(image_show,'3_1_image_decode.jpg')
%imwrite(image_show,'2_11_decode.jpg')

% PSNR evaluate
load hall.mat
MSE = 0;
for x = 1:h
    for y = 1:w
        MSE = MSE + (double(hall_gray(x,y))-image_decode(x,y)).^2;
        %MSE = MSE + (double(snow(x,y))-image_decode(x,y)).^2;
    end
end
MSE = MSE/(h*w);
PSNR = 10*log10(255*255/MSE);
com_rate = h*w*8/(length(DC_stream)+length(AC_stream));
fprintf('PSNR = %d\n',PSNR);
fprintf('Ñ¹Ëõ±È = %d\n',com_rate);
%imwrite(snow,'snow_origin.jpg')
%imwrite(image_show,'snow_decode.jpg')




