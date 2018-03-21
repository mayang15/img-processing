function A = str2matrix(s,len)
i = 0;
while i < len-length(s)
    A(i+1) = 0;
    i = i + 1;
end
i = i + 1;
j = 0;
while j < length(s)
    A(i+j) = str2num(s(j+1));
    j = j + 1;
end
end