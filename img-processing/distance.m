function dist = distance(u, v)
sum = 0;
for i = 1:length(u)
    sum = sum + sqrt(u(i)*v(i));
end
dist = 1 - sum;
end