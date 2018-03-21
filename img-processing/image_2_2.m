clear, clc;
load hall.mat
N = 120;
P = double(hall_gray(1:N,1:N));
D = zeros(N,N);
D(1,:) = 1/sqrt(2);
for i = 2:N
    for j = 1:N
        D(i,j) = cos((i-1)*(2*j-1)*pi/2/N);
    end
end
D = sqrt(2/N)*D;
C = D*P*D';
C2 = dct2(P);
diff = C-C2;
imshow(diff)