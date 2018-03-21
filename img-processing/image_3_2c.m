% 变换域信息隐藏 方法二
clear,clc;
load hall.mat
load JpegCoeff.mat

% background image
image = double(hall_gray);
imshow(uint8(image))
[h,w] = size(image);

% hidden information
message = ones(1,h*w/64);
message(1:8) = [1,-1,1,1,1,-1,-1,1];

% JPEG coding
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
        image_block_q{x,y}(1:8,1:8) = round(image_block_dct{x,y}(1:8,1:8)./QTAB);
    end
end

% entropy coding
hall_q = zeros(64,h*w/64);
for i = 1:h*w/64
    hall_q(:,i) = zigzag(image_block_q{ceil(i/(w/8)),i-(ceil(i/(w/8))-1)*(w/8)});
end

% information hidding
for i = 1:h*w/64
    for j = 1:64
        if hall_q(j,i) ~= 0
            if j == 64
                last = 64;
            else
                last = j + 1;
            end
        end  
    end
    hall_q(last,i) = message(i);
end

% DC coding
DC_forecast_err = zeros(1,h*w/64);
DC_forecast_err(1) = hall_q(1,1);
for j = 2:h*w/64
    DC_forecast_err(j) = hall_q(1,j-1)-hall_q(1,j);
end
DC_stream = DC_coding(DC_forecast_err, DCTAB, h, w);
%AC coding
AC_stream = AC_coding(hall_q, ACTAB, h, w);

% JPEG decoding
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
for x = 1:h/8
    for y = 1:w/8
        % partitioning
        result_block_a{x,y}(1:8,1:8) = coeff_q(1+(x-1)*8:x*8,1+(y-1)*8:y*8);
    end
end
hall_q_decode = zeros(64,h*w/64);
for i = 1:h*w/64
    hall_q_decode(:,i) = zigzag(result_block_a{ceil(i/(w/8)),i-(ceil(i/(w/8))-1)*(w/8)});
end

% information extrating
get_message = zeros(1,h*w/64);
for i = 1:h*w/64
    for j = 1:64
        if hall_q_decode(j,i) ~= 0
            last = j;
        end  
    end
    get_message(i) = hall_q_decode(last,i);
end
diff = get_message-message;


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

image_show = uint8(image_decode);
imshow(image_show)
imwrite(image_show,'3_2c.jpg')

% PSNR evaluate
load hall.mat
MSE = 0;
for x = 1:h
    for y = 1:w
        MSE = MSE + (double(hall_gray(x,y))-image_decode(x,y)).^2;
    end
end
MSE = MSE/(h*w);
PSNR = 10*log10(255*255/MSE);
com_rate = h*w*8/(length(DC_stream)+length(AC_stream));
fprintf('PSNR = %d\n',PSNR);
fprintf('压缩比 = %d\n',com_rate);



