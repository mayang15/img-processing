% 变换域信息隐藏 方法二
clear,clc;
load hall.mat
load JpegCoeff.mat

% background image
image = double(hall_gray);
imshow(uint8(image))
[h,w] = size(image);

% hidden information
words = dec2bin('I love you!');
[r,c] = size(words);
message = zeros(1,r*c);
f = 1;
for i = 1:r
    for j = 1:c
        message(f) = str2num(words(i,j));
        f = f + 1;
    end
end

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
% information hidding
t = 1;
for x = 1:h/8
    if t == length(message)+1
        break
    end
    for y = 1:w/8
        if t == length(message)+1
            break
        end
        for i = 1:8
            if t == length(message)+1
                break
            end
            for j = 1:8
                if t == length(message)+1
                    break
                end
                if image_block_q{x,y}(i,j) < 0
                    s = dec2bin(-image_block_q{x,y}(i,j)); % 不用补码
                    s(end) = num2str(message(t));
                    image_block_q{x,y}(i,j) = -bin2dec(s);
                    t = t + 1; 
                else
                    s = dec2bin(image_block_q{x,y}(i,j));
                    s(end) = num2str(message(t));
                    image_block_q{x,y}(i,j) = bin2dec(s);
                    t = t + 1;
                end
            end
        end
    end
end
% entropy coding
hall_q = zeros(64,h*w/64);
for i = 1:h*w/64
    hall_q(:,i) = zigzag(image_block_q{ceil(i/(w/8)),i-(ceil(i/(w/8))-1)*(w/8)});
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
% information extrating
get_message = zeros(1,r*c);
result_block_a = cell(h/8,w/8);
t = 1;
for x = 1:h/8
    for y = 1:w/8
        % partitioning
        result_block_a{x,y}(1:8,1:8) = coeff_q(1+(x-1)*8:x*8,1+(y-1)*8:y*8);              
    end
end
for x = 1:h/8
    if t == r*c+1
        break;
    end
    for y = 1:w/8
        if t == r*c+1
            break;
        end
        for i = 1:8
            if t == r*c+1
                break;
            end
            for j = 1:8
                if t == r*c+1
                    break;
                end
                if result_block_a{x,y}(i,j) < 0
                    s = dec2bin(-result_block_a{x,y}(i,j));
                    get_message(t) = str2num(s(end));
                    t = t + 1;
                else
                    s = dec2bin(result_block_a{x,y}(i,j));
                    get_message(t) = str2num(s(end));
                    t = t + 1;
                end
            end
        end
    end
end
diff = get_message - message;
words_decode = zeros(r,c);
f = 1;
for i = 1:r
    for j = 1:c
        words_decode(i,j) = message(f);
        f = f + 1;
    end
end
mes_decode = char(bin2dec(char(words_decode+48)));

result_block_b = cell(h/8,w/8);
image_decode = zeros(h,w);
for x = 1:h/8
    for y = 1:w/8
        % inverse quantization
        result_block_b{x,y}(1:8,1:8) = result_block_a{x,y}(1:8,1:8).*QTAB;
        % IDCT and splice
        image_decode((x-1)*8+1:x*8,(y-1)*8+1:y*8) = idct2(result_block_b{x,y}(1:8,1:8))+128;
    end
end

image_show = uint8(image_decode);
imshow(image_show)
imwrite(image_show,'3_2b.jpg')

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



