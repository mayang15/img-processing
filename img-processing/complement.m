function c = complement(b)
c = b;
for i = 1:length(b)
    if b(i) == '1'
        c(i) = '0';
    else
        c(i) = '1';
    end
end
end