function image_jpeg = JPEG(image_ori)
% jpeg coder
load JpegCoeff.mat
[h,w] = size(image_ori);
image = double(image_ori);
image_block = cell(h/8,w/8);
image_block_dct = cell(h/8,w/8);
image_block_q = cell(h/8,w/8);
for x = 1:h/8
    for y = 1:w/8
        % partitioning & preprocessing
        image_block{x,y}(1:8,1:8) = image(1+(x-1)*8:x*8,1+(y-1)*8:y*8)-128;
        % DCT
        image_block_dct{x,y}(1:8,1:8) = dct2(image_block{x,y}(1:8,1:8));
        % quantization
        image_block_q{x,y}(1:8,1:8) = round(image_block_dct{x,y}(1:8,1:8));%./QTAB*2);
    end
end
% entropy coding
image_q = zeros(64,h*w/64);
for i = 1:h*w/64
    image_q(:,i) = zigzag(image_block_q{ceil(i/(w/8)),i-(ceil(i/(w/8))-1)*(w/8)});
end
% DC coding
DC_forecast_err = zeros(1,h*w/64);
DC_forecast_err(1) = image_q(1,1);
for j = 2:h*w/64
    DC_forecast_err(j) = image_q(1,j-1)-image_q(1,j);
end
DC_stream = DC_coding(DC_forecast_err, DCTAB, h, w);
%AC coding
AC_stream = AC_coding(image_q, ACTAB, h, w);
save('jpegcodes.mat','h','w','DC_stream','AC_stream');

% jpeg decoder
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
        result_block_b{x,y}(1:8,1:8) = result_block_a{x,y}(1:8,1:8);%.*QTAB;
        % IDCT and splice
        image_decode((x-1)*8+1:x*8,(y-1)*8+1:y*8) = idct2(result_block_b{x,y}(1:8,1:8))+128;
    end
end
image_show = uint8(image_decode);
imshow(image_show)
imwrite(image_show,'3_2_image_decode.jpg')
image_jpeg = image_decode;

% PSNR evaluate
MSE = 0;
for x = 1:h
    for y = 1:w
        %MSE = MSE + (double(hall_gray(x,y))-image_decode(x,y)).^2;
        %MSE = MSE + (double(snow(x,y))-image_decode(x,y)).^2;
        MSE = MSE + (double(image_jpeg(x,y)-image_ori(x,y))).^2;
    end
end
MSE = MSE/(h*w);
PSNR = 10*log10(255*255/MSE);
com_rate = h*w*8/(length(DC_stream)+length(AC_stream));
fprintf('PSNR = %d\n',PSNR);
fprintf('Ñ¹Ëõ±È = %d\n',com_rate);
end