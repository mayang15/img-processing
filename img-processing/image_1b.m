clear,clc;
load hall.mat
hall_double = im2double(hall_color);
[rows, cols, channels] = size(hall_double);

tag_x = 0;
for x = 1:rows
    tag_x = tag_x + 1;
    if tag_x <= 15
        black_x = 1;
    else
        black_x = 0;
    end
    if tag_x == 30
        tag_x = 0;
    end
    
    tag_y = 0;
    for y = 1:cols
        tag_y = tag_y + 1;
        if tag_y <= 21
            black_y = 1;
        else
            black_y = 0;
        end
        if tag_y == 42
            tag_y = 0;
        end
        
        if black_x && black_y == 1
             hall_double(x,y,1:3) = [0 0 0];
        else if ~black_x && ~black_y ==1
                hall_double(x,y,1:3) = [0 0 0];
            end
        end
    end
end

imwrite(hall_double, '1b_chess.jpg')
figure
subplot(1,2,1)
imshow(hall_color)
subplot(1,2,2)
imshow(hall_double)
saveas(gcf,'1b_compare.jpg')


