clear, clc;
load hall.mat
hall_double = im2double(hall_color);
[rows,cols,channels] = size(hall_double);
r = min([rows cols])/2;
ori = [round(rows/2) round(cols/2)];
for x = 1:rows
    for y = 1:cols
        if (ori(1)-x)^2+(ori(2)-y)^2 <= r^2
            hall_double(x,y,1:3) = [1 0 0];
        end
    end
end
imwrite(hall_double, 'circle.jpg');
figure
subplot(1,2,1)
imshow(hall_color)
subplot(1,2,2)
imshow(hall_double)
saveas(gcf,'compare.jpg')
