clear,clc;
load v.mat
thre = 0.84;
L = 4;
v_test = v4;
image_ori = double(imread('face5.jpg'));
% image_ori = imadjust(image_ori/255,[.1 .1 0; .8 .8 1],[]);
% image_ori = image_ori*255;
% image_ori = imrotate(image_ori,-90);
% [rowsx, colsx, channelsx] = size(image_ori);
% image_ori = imresize(image_ori,[rowsx colsx*2]);
[rows, cols, channels] = size(image_ori);
temp = image_ori(:,:,1);
% G*G blocks
G = 4;
image = zeros(ceil(rows/G)*G, ceil(cols/G)*G, 3);
image(1:rows, 1:cols, :) = double(uint8(image_ori));
[h, w, cha] = size(image);
figure
imshow(uint8(image));
rect = zeros(h/G,w/G);
for x = 1:h/G
    for y = 9:w/G
        block = image(1+(x-1)*G:x*G, 1+(y-1)*G:y*G, :);
        % compute the eigenvector of each block
        u = eigenvector(block, G, L);
        sum = 0;
        for i = 1:length(u)
            sum = sum + u(i);
        end
        % compute the distance
        t = distance(u, v_test);
        if distance(u, v_test) < thre
            hold on, rectangle('Position',[(y-1)*G,(x-1)*G,G,G],'edgecolor','r');
            rect(x,y) = 1;
        end
%         fprintf('x:%d,y:%d,sum of u:%d,dist:%d\n',x,y,sum,t);
    end
end
rect_f1 = boxfilter(rect);
rect_f2 = boxfilter(rect_f1); 
for x = 1:h/G
    for y = 1:w/G
        if rect_f2(x,y) > 0.4
            rect_f2(x,y) = 1;
        else
            rect_f2(x,y) = 0;
        end
    end
end
figure
imshow(uint8(image));
for x = 1:h/G
    for y = 1:w/G
        if rect_f2(x,y) == 1
            hold on, rectangle('Position',[(y-1)*G,(x-1)*G,G,G],'edgecolor','r');
        end
    end
end

% rect_f2 = rect;
[con_region, num] = bwlabel(rect_f2);
region = regionprops(con_region, 'Area', 'BoundingBox');
figure
imshow(uint8(image))
for i = 1:num
    if region(i).Area > 5
        box = region(i).BoundingBox;
        hold on, rectangle('Position',[(box(1)-1)*G, (box(2)-1)*G, box(3)*G, box(4)*G], 'edgecolor','r');
    end
end

