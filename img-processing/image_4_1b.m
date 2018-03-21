clear,clc;
load v.mat
L = 5; % 3 or 4 or 5
N = 2 ^ (3 * L);
pack = 2 ^ (3 * (8 - L));
v5 = zeros(N, 1);
for i = 1:N
    for k = 1:pack
        v5(i) = v5(i) + v((i-1) * pack + k); 
    end
end
save('v.mat','v','v3','v4','v5')
% sum = 0;
% for i = 1:N
%     sum = sum + v2(i);
% end