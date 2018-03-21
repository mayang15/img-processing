clear,clc;
L = 8;
N = 2 ^ (3 * L);
v = zeros(N, 1);
for i = 1:33
    image = double(imread(sprintf('Faces/%d.bmp',i)));
    [rows, cols, channels] = size(image);
    u = zeros(N, 1);
    c_n = zeros(1, 3*L) + 48; 
    for x = 1:rows
        for y = 1:cols
            c_n(L-length(dec2bin(image(x,y,1)))+1:L) = dec2bin(image(x,y,1));
            c_n(2*L-length(dec2bin(image(x,y,2)))+1:2*L) = dec2bin(image(x,y,2));
            c_n(3*L-length(dec2bin(image(x,y,3)))+1:3*L) = dec2bin(image(x,y,3));
            t = bin2dec(char(c_n));
            u(t+1) = u(t+1) + 1;
        end
    end
    u = u / (rows*cols);
    v = v + u;
end
v = v / 33;
save('v.mat','v');
