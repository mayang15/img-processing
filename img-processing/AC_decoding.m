function AC_coeff = AC_decoding(AC_stream, ACTAB, h, w)
temp = AC_stream(end-3:end);
ac_coeff = zeros(64,h*w/64);  % each colum represents a block
current_str = '';
%flag = 0;
RUN = -1;
SIZE = -1;
num = 1;  % current block: num/64
count = 1;  % num of elements in current block
i = 1;
while i <= length(AC_stream)
    current_str = [current_str,AC_stream(i)];
    if strcmp(current_str,'1010')  % EOB
        num = num + 1;
        count = 1;
        current_str = '';
        i = i + 1;
        % fprintf('%d/%d num of block\n',num-1,h*w/64);
        continue;
    end
    if strcmp(current_str,'11111111001')  % 16 zeros
        m = 0;
        count = count + 16;
        current_str = '';
        i = i + 1;
        continue;
    end
    same_len = find((ACTAB(:,3)-length(current_str))==0);
    for g = 1:length(same_len)
        L = ACTAB(same_len(g),3);
        if strcmp(current_str,matrix2str(ACTAB(same_len(g),4:(3+L))))
            RUN = ACTAB(same_len(g),1);
            SIZE = ACTAB(same_len(g),2);
            % filling zeros
            t = 0;
            while t < RUN
                count = count + 1;
                t = t + 1;
            end
            % filling not zero element
            if strcmp(AC_stream(i+1),'0')
                count = count + 1;
                ac_coeff(count,num) = -bin2dec(complement(AC_stream(i+1:i+SIZE)));
            else
                count = count + 1;
                ac_coeff(count,num) = bin2dec(AC_stream(i+1:i+SIZE));
            end
            current_str = '';
            i = i + SIZE;
            break
        end
    end
    i = i + 1;
end
% inverse zigzag
AC_coeff = zeros(h,w);
for x = 1:h/8
    for y = 1:w/8
        AC_coeff((x-1)*8+1:x*8,(y-1)*8+1:y*8) = i_zigzag(ac_coeff(:,(x-1)*w/8+y));
    end
end
end