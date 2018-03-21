clear,clc;
load hall.mat
load JpegCoeff.mat
image = double(hall_gray);
hall_block = cell(15,21);
hall_block_dct = cell(15,21);
hall_block_q = cell(15,21);
for x = 1:15
    for y = 1:21
        hall_block{x,y}(1:8,1:8) = image(1+(x-1)*8:x*8,1+(y-1)*8:y*8)-128;
        hall_block_dct{x,y}(1:8,1:8) = dct2(hall_block{x,y});
        hall_block_q{x,y}(1:8,1:8) = round(hall_block_dct{x,y}./QTAB);
    end
end
hall_q = zeros(64,315);
for i = 1:315
    hall_q(:,i) = zigzag(hall_block_q{ceil(i/21),i-(ceil(i/21)-1)*21});
end







