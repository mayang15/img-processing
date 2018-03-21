% jpeg coder
clear, clc;
load JpegCoeff.mat
load hall.mat
[h,w] = size(hall_gray);
image = double(hall_gray);

hall_block = cell(h/8,w/8);
hall_block_dct = cell(h/8,w/8);
hall_block_q = cell(h/8,w/8);
for x = 1:h/8
    for y = 1:w/8
        % partitioning & preprocessing
        hall_block{x,y}(1:8,1:8) = image(1+(x-1)*8:x*8,1+(y-1)*8:y*8)-128;
        % DCT
        hall_block_dct{x,y}(1:8,1:8) = dct2(hall_block{x,y}(1:8,1:8));
        % quantization
        hall_block_q{x,y}(1:8,1:8) = round(hall_block_dct{x,y}(1:8,1:8)./QTAB);
    end
end
% entropy coding
hall_q = zeros(64,h*w/64);
for i = 1:h*w/64
    hall_q(:,i) = zigzag(hall_block_q{ceil(i/(w/8)),i-(ceil(i/(w/8))-1)*(w/8)});
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

save('jpegcodes.mat','h','w','DC_stream','AC_stream');




