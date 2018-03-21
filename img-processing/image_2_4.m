clear, clc;
load hall.mat
N = 64;
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

% %×ªÖÃ
% C = C';

%Ðý×ª90¡ã,180¡ã
C = rot90(C);
C = rot90(C);

P2 = D'*C*D;
diff = P-P2;
figure
subplot(1,2,1)
imshow(uint8(P))
subplot(1,2,2)
imshow(uint8(P2))
