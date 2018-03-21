function str = matrix2str(A)
str = '';
for i = 1:length(A)
    str = [str, num2str(A(i))];
end
end