function DC_coeff = DC_decoding(DC_stream, DCTAB, h, w)
% DC_stream -> DC forecast error
DC_err = zeros(1,h*w/64);
current_str = '';
flag = 0;
Cate = -1;
count = 0;
i = 1;
while i <= length(DC_stream)
    current_str = [current_str,DC_stream(i)];
    for j = 1:12
        L = DCTAB(j,1);
        if strcmp(current_str,matrix2str(DCTAB(j,2:(1+L))))
            flag = 1;
            count = count + 1;
            Cate = j-1;
            if Cate == 0
                DC_err(count) = 0;
                i = i + 1;
            else
                if strcmp(DC_stream(i+1),'0')  
                    DC_err(count) = -bin2dec(complement(DC_stream(i+1:i+Cate)));
                    i = i + Cate;
                else
                    DC_err(count) = bin2dec(DC_stream(i+1:i+Cate));
                    i = i + Cate;
                end
            end
            break
        end
    end
    if flag == 1
        flag = 0;
        current_str = '';   
    end
    i = i + 1;
end
% DC forecast error -> DC coefficient
DC_coeff = zeros(1,h*w/64);
DC_coeff(1) = DC_err(1);
for k = 2:h*w/64
    DC_coeff(k) = DC_coeff(k-1) - DC_err(k);  
end
end