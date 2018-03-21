function u = eigenvector(image, G, L)
N = 2 ^ (3 * L);
pack = 2 ^ (3 * (8 - L));
u = zeros(N, 1);
c_n = zeros(1, 24) + 48; 
for x = 1:G
    for y = 1:G
        c_n(8-length(dec2bin(image(x,y,1)))+1:8) = dec2bin(image(x,y,1));
        c_n(2*8-length(dec2bin(image(x,y,2)))+1:2*8) = dec2bin(image(x,y,2));
        c_n(3*8-length(dec2bin(image(x,y,3)))+1:3*8) = dec2bin(image(x,y,3));
        t = bin2dec(char(c_n));
        u(ceil((t+1)/pack)) = u(ceil((t+1)/pack)) + 1;
    end
end
u = u / (G*G);
sum = 0;
% for i = 1:N
%     sum = sum + u(i);
% end
end