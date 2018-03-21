function AC_str = AC_coding(hall_q, ACTAB, h, w)
AC_str = '';
for i = 1:h*w/64   % for each block's line
    Run = 0;
    for j = 2:64   
        if hall_q(j,i) == 0
            Run = Run + 1;
            continue;
        end
        % if not zero        
        if Run >= 16
            num_16 = floor(Run/16);
            u = 0;
            while u < num_16
                AC_str = [AC_str,'11111111001'];
                u = u + 1;
            end
            Run = Run - num_16*16; 
        end
        if hall_q(j,i) < 0
            Size = length(dec2bin(-hall_q(j,i)));
            for x = 1:160
                if (ACTAB(x,1) == Run) && (ACTAB(x,2) == Size)
                    L = ACTAB(x,3);
                    AC_str = [AC_str,matrix2str(ACTAB(x,4:3+L)),complement(dec2bin(-hall_q(j,i)))];
                    break;
                end
            end
        else
            Size = length(dec2bin(hall_q(j,i)));
            for x = 1:160
                if (ACTAB(x,1) == Run) && (ACTAB(x,2) == Size)
                    L = ACTAB(x,3);
                    AC_str = [AC_str,matrix2str(ACTAB(x,4:3+L)),dec2bin(hall_q(j,i))];
                    break;
                end
            end
        end
        Run = 0;
    end
    AC_str = [AC_str,'1010'];  
end
end