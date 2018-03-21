% 空域信息隐藏&提取
clear,clc;
load hall.mat
image_me = double(hall_gray);
message = ones(1,120*168);
t = 1;
for i = 1:120
    for j = 1:168
        s = dec2bin(image_me(i,j));
        s(end) = num2str(message(t));
        image_me(i,j) = bin2dec(s);
        t = t + 1;
    end
end
imwrite(uint8(image_me),'image_me.bmp');
image_jpeg = JPEG(image_me);
[h,w] = size(image_jpeg);
imshow(uint8(image_jpeg));
message_2 = zeros(1,120*168);
t = 1;
for i = 1:h
    for j = 1:w
        r = dec2bin(uint8(image_jpeg(i,j)));
        z = r(end);
        message_2(t) = str2num(z);
        t = t + 1;
    end
end


